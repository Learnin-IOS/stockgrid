//
//  ChartView.swift
//  stockgrid
//
//  Created by Le Bon B' Bauma on 01/04/2023.
//

import Charts
import StocksAPI
import SwiftUI

struct ChartView: View {
    let data: ChartViewData
    @ObservedObject var vm: ChartViewModel
    
    
    var body: some View {
        chart
            .chartXScale(domain: data.items.first!.timestamp...data.items.last!.timestamp)
            .chartYScale(domain: data.yAxisData.axisStart...data.yAxisData.axisEnd)
            .chartPlotStyle { chartPlotStyle($0) }
            .chartOverlay { proxy in
                GeometryReader { gProxy in
                    Rectangle().fill(.clear).contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged {
                                    onChangeDrag(
                                        value: $0,
                                        chartProxy: proxy,
                                        geomertyProxy: gProxy)
                                }
                                .onEnded{ _ in
                                    vm.selectedX = nil
                                }
                        )
                    }
            }
    }
    
    private var chart: some View  {
        Chart {
            ForEach(data.items) {
                LineMark(
                    x: .value("Time", $0.timestamp),
                    y: .value("Price", $0.value)
                )
                .foregroundStyle(vm.foregroundMarkColor)
                
                AreaMark (
                    x: .value("Time", $0.timestamp),
                    yStart: .value("Min", data.yAxisData.axisStart),
                    yEnd: .value("Max", $0.value)
                    
                )
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [
                    vm.foregroundMarkColor,
                    .clear
                ]), startPoint: .top, endPoint: .bottom)
                    .opacity(0.5))
                
                if let previousClose = data.previousCloseRuleMarkValue {
                    RuleMark(y: .value("Previous Close", previousClose))
                        .lineStyle(.init(lineWidth: 0.1, dash: [2]))
                        .foregroundStyle(.gray.opacity(0.3))
                }
                
                if let (selectedX, text) = vm.selectedRuleMark {
                    RuleMark(x: .value("Selected timestamp", selectedX))
                        .lineStyle(.init(lineWidth: 1))
                        .annotation {
                            Text(text)
                                .font(.system(size: 14))
                                .foregroundColor(.blue)
                        }
                        .foregroundStyle(vm.foregroundMarkColor)
                }
            }
        }
    }
    
    private func chartPlotStyle(_ plotContent: ChartPlotContent) -> some View {
        plotContent
            .frame(height: 200)
            .overlay {
                Rectangle()
                    .foregroundColor(.gray.opacity(0.5))
                    .mask(ZStack {
                        VStack {
                            Spacer()
                            Rectangle().frame(height: 1)
                        }
                        
                        HStack {
                            Spacer()
                            Rectangle().frame(width: 0.3)
                        }
                        
                    })
            }
    }
    
    private func onChangeDrag(value: DragGesture.Value, chartProxy: ChartProxy, geomertyProxy: GeometryProxy) {
        let xCurrent = value.location.x - geomertyProxy[chartProxy.plotAreaFrame].origin.x
        if let timestamp: Date = chartProxy.value(atX: xCurrent),
           let startDate = data.items.first?.timestamp,
           let lastDate = data.items.last?.timestamp,
           timestamp >= startDate && timestamp <= lastDate {
            vm.selectedX = timestamp
        }
    }
    
}

struct ChartView_Previews: PreviewProvider {
    
    static var allRanges = ChartRange.allCases
    static var oneDayOngoing = ChartData.stub1DOngoing
    
    static var previews: some View {
        ForEach(allRanges) {
            ChartContainer_Previews(vm: chartViewModel(range: $0, stub: $0.stubs), title: $0.title)
        }
        
        ChartContainer_Previews(vm: chartViewModel(range: .oneDay, stub: oneDayOngoing), title: "1D Ongoing")
    }
    
    static func chartViewModel(range: ChartRange, stub: ChartData) -> ChartViewModel {
        var mockStocksAPI = MockStocksAPI()
        mockStocksAPI.stubFetchChartDataCallback = { _ in stub }
        let chartVM =  ChartViewModel(ticker: .stub, apiService: mockStocksAPI )
        return chartVM
    }
}

#if DEBUG
struct ChartContainer_Previews: View {
    @StateObject var vm: ChartViewModel
    let title: String

    var body: some View {
        VStack {
            Text(title)
                .padding(.bottom)
            if let chartViewData = vm.chart {
                ChartView(data: chartViewData, vm: vm)
            }
        }
        .padding()
        .frame(maxHeight: 272)
        .previewLayout(.sizeThatFits)
        .previewDisplayName(title)
        .task { await vm.fetchData()}
    }
}

#endif
