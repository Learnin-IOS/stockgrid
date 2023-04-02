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
    
    
    var body: some View {
        chart
            .chartYScale(domain: data.items.map { $0.value }.min()!...data.items.map { $0.value }.max()!)
//            .chartXAxis {
//                AxisMarks(format: Date.FormatStyle(
//                    date: .omitted,
//                    time: .shortened,
//                    timeZone: TimeZone(secondsFromGMT: -14400)!
//                    )
//                )
//            }
    }
    
    private var chart: some View  {
        Chart {
            ForEach(data.items) {
                LineMark(
                    x: .value("Time", $0.timestamp),
                    y: .value("Price", $0.value)
                )
            }
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
            if let chartViewData = vm.chart {
                ChartView(data: chartViewData)
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
