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
     
    func openYahooFinance() {
        let url = URL(string: "https://finance.yahoo.com")!
        guard UIApplication.shared.canOpenURL(url) else  { return }
        UIApplication.shared.open(url)
    }
}
