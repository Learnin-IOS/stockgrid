//
//  MockStoksAPI.swift
//  stockgrid
//
//  Created by Le Bon B' Bauma on 15/03/2023.
//

import Foundation
import StocksAPI

#if DEBUG
    
struct MockStocksAPI: StockAPI {
    
    var stubbedSearchTickersCallback: (() async throws -> [Ticker])!
    func searchTickers(query: String, isEquityTypeOnly: Bool) async throws -> [Ticker] {
        try await stubbedSearchTickersCallback()
    }
    
    var stubbedFetchQuotesCallback: (() async throws -> [Quote])!
    func fetchQuotes(symbols: String) async throws -> [Quote] {
        try await stubbedFetchQuotesCallback()
    }
    
    
    func fetchChartData(symbol: String, range: ChartRange) async throws -> ChartData? {
        nil
    }
    
}

#endif
