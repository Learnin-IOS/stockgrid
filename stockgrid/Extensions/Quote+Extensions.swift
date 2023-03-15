//
//  Quote+Extensions.swift
//  stockgrid
//
//  Created by Le Bon B' Bauma on 11/03/2023.
//

import Foundation
import StocksAPI

extension Quote {
    
    var regularPriceText: String? {
        Utils.format(value: regularMarketPrice)
    }
    
    var regularDiffText: String? {
        guard let text = Utils.format(value: regularMarketChange) else { return nil }
        return text.hasPrefix("-") ? text : "+\(text)"
    }
    
}
