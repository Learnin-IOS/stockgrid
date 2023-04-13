//
//  ChartViewModel.swift
//  stockgrid
//
//  Created by Le Bon B' Bauma on 23/03/2023.
//

import Foundation
import Charts
import SwiftUI
import StocksAPI

@MainActor
class ChartViewModel: ObservableObject {
    
    @Published var fetchPhase = FetchPase<ChartViewData>.initial
    var chart: ChartViewData? { fetchPhase.value }
    
    let ticker: Ticker
    let apiService: StockAPI
    
    @AppStorage("selectedRange") private var _range = ChartRange.oneDay.rawValue
    
    @Published var selectedRange = ChartRange.oneDay {
        didSet {
            _range = selectedRange.rawValue
        }
    }
    
    @Published var selectedX: (any Plottable)?
    
    var selectedRuleMark: (value: Date, text: String)? {
        
        guard let selectedX = selectedX as? Date,
              let chart
        else { return nil }
        let index = DateBins(thresholds: chart.items.map { $0.timestamp }).index(for: selectedX)
        return (selectedX, String(format: "%.2f", chart.items[index].value))
    }
    
    var foregroundMarkColor: Color {
        (selectedX != nil) ? .cyan : (chart?.lineColor ?? .cyan)
    }
    
    init(ticker: Ticker, apiService: StockAPI = StocksAPI()) {
        self.ticker = ticker
        self.apiService = apiService
        self.selectedRange = ChartRange(rawValue: _range) ?? .oneDay
    }
    
    private let selectedValueDateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()
    
    var selectedXDateText: String {
        guard let selectedX = selectedX as? Date, let chart else  { return "" }
        if selectedRange == .oneDay || selectedRange == .oneWeek {
            selectedValueDateFormatter.timeStyle = .short
        } else {
            selectedValueDateFormatter.timeStyle = .none
        }
        let index = DateBins(thresholds: chart.items.map { $0.timestamp }).index(for: selectedX)
        let item = chart.items[index]
        return selectedValueDateFormatter.string(from: item.timestamp)
    }
    
    var selectedXOpacity: Double {
        selectedX == nil ? 1 : 0
    }
 
    func fetchData() async {
        
        do {
            
            fetchPhase = .fetching
            let rangeType = self.selectedRange
            let chatData = try await apiService.fetchChartData(symbol: ticker.symbol, range: rangeType)
            
            guard rangeType == self.selectedRange else { return }
            if let chatData {
                fetchPhase = .success(transformChartViewData(chatData))
            } else   {
                fetchPhase = .empty
            }
            
        } catch  {
            fetchPhase = .failure(error)
        }
    }
    
    func transformChartViewData(_ data: ChartData)  -> ChartViewData {
        
        let items = data.indicators.map { ChartViewItem(timestamp: $0.timestamp, value: $0.close)}
        let yAxisChartData = yAxisChartData(data)
        return ChartViewData(
            yAxisData: yAxisChartData,
            items: items,
            lineColor: getLineColor(data: data),
            previousCloseRuleMarkValue: previousCloseRuleMarkValue(data: data, yAxisData: yAxisChartData)
        )
    }
    
    
    func yAxisChartData(_ data : ChartData) -> ChartAxisData {
        
        let closes = data.indicators.map { $0.close }
        var lowest = closes.min() ?? 0
        var highest = closes.max() ?? 0
        
        if let prevClose = data.meta.previousClose, selectedRange == .oneDay {
            if prevClose < lowest {
                lowest = prevClose
            } else if prevClose > highest{
                highest = prevClose
            }
        }
        
        return ChartAxisData(
            axisStart: lowest + 0.01 ,
            axisEnd: highest + 0.01
        )
    }
    
    func previousCloseRuleMarkValue(data: ChartData, yAxisData: ChartAxisData) -> Double? {
        
        guard let previousClose = data.meta.previousClose, selectedRange == .oneDay else { return nil }
        return (yAxisData.axisStart <= previousClose && previousClose <= yAxisData.axisEnd) ? previousClose : nil
        
    }
    
    
    func getLineColor(data: ChartData) -> Color {
        
        if let last = data.indicators.last?.close {
            if selectedRange == .oneDay, let prevClose = data.meta.previousClose {
                return last >= prevClose ? .green : .red
            } else if let first = data.indicators.first?.close {
                return last >= first ? .green : .red
            }
        }
        return .blue
    }
}
