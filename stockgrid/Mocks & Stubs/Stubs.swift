//
//  Stubs.swift
//  stockgrid
//
//  Created by Le Bon B' Bauma on 07/03/2023.
//

import Foundation
import StocksAPI


#if DEBUG
extension Ticker {
    
    static var stubs: [Ticker] {
        [
            Ticker(symbol: "AAPL", shortname: "Apple Inc."),
            Ticker(symbol: "TSLA", shortname: "Tesla"),
            Ticker(symbol: "NVDA", shortname: "Nvidia Corp"),
            Ticker(symbol: "AMD", shortname: "Advavnced Micro Device ")
        ]
    }
}

#endif
