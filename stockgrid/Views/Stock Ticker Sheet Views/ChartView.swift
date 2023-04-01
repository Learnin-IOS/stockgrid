//
//  ChartView.swift
//  stockgrid
//
//  Created by Le Bon B' Bauma on 01/04/2023.
//

import Charts
import StocksAPI
import SwiftUI

struct ChartView: View {
    let data: ChartViewData
    
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ChartView_Previews: PreviewProvider {
    
    static var allRanges = ChartRange.allCases
    static var oneDayOngoing = ChartData.stub1DOngoing
    
    static var previews: some View {
        ChartView()
    }
    
    static func chartViewModel(range: ChartRange, stub: ChartData) -> ChartViewModel {
        var mockStocksAPI
    }
}

#if DEBUG
struct ChartContainer_Previews: View {
    @StateObject var vm: ChartViewModel
    let title: String
    
    
    var body: some View {
        VStack {
            Text(title)
            if let chartViewData = vm.chart {
                ChartView(data: chartViewData)
            }
        }
        .padding()
        .frame(maxWidth: 272)
        .previewLayout(.sizeThatFits)
        .previewDisplayName(title)
        .task { await vm.fetchData()}
    }
}

#endif
