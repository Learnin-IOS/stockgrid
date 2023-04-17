//
//  ChartViewData.swift
//  stockgrid
//
//  Created by Le Bon B' Bauma on 20/03/2023.
//

import Foundation
import SwiftUI


struct ChartViewData: Identifiable {
    
    let id = UUID()
    let yAxisData: ChartAxisData
    let items: [ChartViewItem]
    let lineColor: Color
    let previousCloseRuleMarkValue: Double?
}

struct ChartViewItem: Identifiable {
    
    let id = UUID()
    let timestamp: Date
    let value: Double
}


struct ChartAxisData {
    let axisStart: Double
    let axisEnd: Double
    let strideBy: Double
    let map: [String: String]
}
