//
//  TickerListViewData.swift
//  stockgrid
//
//  Created by Le Bon B' Bauma on 06/03/2023.
//

import Foundation

typealias PriceChange = (price: String, change: String)

struct TickerListRawData {
    
    enum rowType {
        case main
        case search(isSaved: Bool, onButtonTapped: () -> () )
    }
    let symbol: String
    let name: String?
    let price: PriceChange?
    let type: rowType
    
    
}
