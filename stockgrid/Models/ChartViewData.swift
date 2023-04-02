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
    let items: [ChartViewItem]
    let lineColor: Color
}

struct ChartViewItem: Identifiable {
    
    let id = UUID()
    let timestamp: Date
    let value: Double
}
