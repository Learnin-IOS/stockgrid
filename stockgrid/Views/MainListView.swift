//
//  MainListView.swift
//  stockgrid
//
//  Created by Le Bon B' Bauma on 03/03/2023.
//

import SwiftUI
import StocksAPI

struct MainListView: View {
    
    // MARK: - Properties
    @EnvironmentObject var appVM: AppViewModel
    @StateObject var quotesVM = QuotesViewModel()
    
    var body: some View {
        tickerListView
    }
    
    private var tickerListView: some View {
        List {
            ForEach(appVM.tickers) { ticker in
                TickerListRowView(
                    data: .init(
                        symbol: ticker.symbol,
                        name: ticker.shortname,
                        price: quotesVM.priceForTicker(ticker ),
                        type: .main))
                
            }
        }
    }
}

struct MainListView_Previews: PreviewProvider {
    
    @StateObject static var appVM: AppViewModel = {
        let vm = AppViewModel()
        vm.tickers = Ticker.stubs
        return vm
    }()
    
    @StateObject static var emptyAppVM: AppViewModel = {
        let vm = AppViewModel()
        vm.tickers = []
        return vm
    }()
    
    @StateObject static var quotesVM: QuotesViewModel = {
        let vm = QuotesViewModel()
        vm.quotesDict = Quote.stubsDict
        return vm
        
    }()
    
    static var previews: some View {
        Group {
            NavigationStack{
                MainListView(quotesVM: quotesVM)
            }
            .environmentObject(appVM)
            .previewDisplayName("With Tickers")
            
            NavigationStack{
                MainListView(quotesVM: quotesVM)
            }
            .environmentObject(emptyAppVM)
            .previewDisplayName("With Empty Tickers")
        }
    }
}
