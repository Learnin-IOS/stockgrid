//
//  ChartRange+Extensions.swift
//  stockgrid
//
//  Created by Le Bon B' Bauma on 19/03/2023.
//

import Foundation
import StocksAPI

extension ChartRange: Identifiable {
    public var id: Self { self }
    var title: String  {
        switch self {
        case .oneDay: return "1D"
        case .oneWeek: return "1W"
        case .oneMonth: return "1M"
        case .threeMonth: return "3M"
        case .sixMonth: return "6M"
        case .oneYear: return "1Y"
        case .twoYear: return "2Y"
        case .fiveYear: return "5Y"
        case .tenYear: return "10Y"
        case .ytd: return "YTD"
        case .max: return "ALL"
        }
    }
}
