//
//  AppViewModel.swift
//  stockgrid
//
//  Created by Le Bon B' Bauma on 07/03/2023.
//

import Foundation
import StocksAPI
import SwiftUI


@MainActor
class AppViewModel: ObservableObject {
    
    @Published var tickers: [Ticker] = []
    
    
    var titleText = "Stockgrid"
    @Published var subtitleText: String
    var emptyTickersText = "Search & Add symbol to see stock quotes"
    var attributionText = "Powered by Yahoo! Finance API"
    
    
    
    private let subtitleDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "d MMM"
        return df
    }()
    
    init() {
        self.subtitleText = subtitleDateFormatter.string(from: Date())
    }
    
    func removeTickers(atOffSets offsets: IndexSet) {
        tickers.remove(atOffsets: offsets)
    }
    
    func isAddedToMyTickers(ticker: Ticker) -> Bool {
        tickers.first { $0.symbol == ticker.symbol } != nil
    }
    
    func toggleTicker(_ ticker: Ticker) {
        if isAddedToMyTickers(ticker: ticker) {
             removeFromMyTickers(ticker: ticker)
        } else {
            addToMyTickers(ticker: ticker)
        }
    }
    
    private func addToMyTickers(ticker: Ticker) {
        tickers.append(ticker)
    }
 
    private func removeFromMyTickers(ticker: Ticker) {
        guard let index = tickers.firstIndex(where: { $0.symbol == ticker.symbol }) else { return }
        tickers.remove(at: index)
    }
    
    func openYahooFinance() {
        let url = URL(string: "https://finance.yahoo.com")!
        guard UIApplication.shared.canOpenURL(url) else  { return }
        UIApplication.shared.open(url)
    }
    
    
}
