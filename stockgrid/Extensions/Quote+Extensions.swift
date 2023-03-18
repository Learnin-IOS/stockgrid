//
//  Quote+Extensions.swift
//  stockgrid
//
//  Created by Le Bon B' Bauma on 11/03/2023.
//

import Foundation
import StocksAPI

extension Quote {
    
    var isTrading: Bool {
        guard let marketState, marketState == "REGULAR" else  {
            return false
        }
        return true
    }
    
    var regularPriceText: String? {
        Utils.format(value: regularMarketPrice)
    }
    
    var regularDiffText: String? {
        guard let text = Utils.format(value: regularMarketChange) else { return nil }
        return text.hasPrefix("-") ? text : "+\(text)"
    }
    
    var postPriceText: String? {
        Utils.format(value: postMarketPrice)
    }
    
    var postPriceDiffText: String? {
        guard let text = Utils.format(value: postMarketChange) else { return nil }
        return text.hasPrefix("-") ? text : "+\(text)"
    }
}
