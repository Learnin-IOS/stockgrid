//
//  ChartViewModel.swift
//  stockgrid
//
//  Created by Le Bon B' Bauma on 23/03/2023.
//

import Foundation
import SwiftUI
import StocksAPI

@MainActor
class ChartViewModel: ObservableObject {
    
    @Published var fetchPhase = FetchPase<ChartViewData>.initial
    var chart: ChartViewData? { fetchPhase.value }
    
    let ticker: Ticker
    let apiService: StockAPI
    
    @AppStorage("selectedRange") private var _range = ChartRange.oneDay.rawValue
    
    @Published var selectedRnage = ChartRange.oneDay {
        didSet {
            _range = selectedRnage.rawValue
        }
    }
    
    init(ticker: Ticker, apiService: StockAPI = StocksAPI()) {
        self.ticker = ticker
        self.apiService = apiService
        self.selectedRnage = ChartRange(rawValue: _range) ?? .oneDay
    }
    
    func fetchData() async {
        do {
            
            fetchPhase = .fetching
            let rangeType = self.selectedRnage
            let chatData = try await apiService.fetchChartData(symbol: ticker.symbol, range: rangeType)
            
            guard rangeType == self.selectedRnage else { return }
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
        return ChartViewData(items: items)
    }
}
