//
//  SearchView.swift
//  stockgrid
//
//  Created by Le Bon B' Bauma on 15/03/2023.
//

import SwiftUI
import StocksAPI

struct SearchView: View {
    @EnvironmentObject var appVM: AppViewModel
    @StateObject var quotesVm = QuotesViewModel()
    @ObservedObject var searchVM: SearchViewModel
    
    var body: some View {
        List(searchVM.tickers) { ticker in
            TickerListRowView(
                data: .init(
                    symbol: ticker.symbol,
                    name: ticker.shortname,
                    price: quotesVm.priceForTicker(ticker),
                    type: .search(
                        isSaved: appVM.isAddedToMyTickers(ticker: ticker),
                        onButtonTapped: { appVM.toggleTicker(ticker) }
                    )
                )
            )
            .contentShape(Rectangle())
            .onTapGesture {
                
            }
        }
        .listStyle(.plain)
        .overlay { listSearchOverlay }
    }
    @ViewBuilder
    private var listSearchOverlay: some View {
        switch searchVM.phase {
        case .failure(let error) :
            ErrorStateView(error: error.localizedDescription) {}
        case .empty:
            EmptyStateView(text: searchVM.emptyListText)
        case .fetching:
            LoadingStateView()
        default: EmptyView()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    @StateObject static var stubbedSearchVM: SearchViewModel = {
        let vm = SearchViewModel()
        vm.phase = .success(Ticker.stubs)
        return vm
    }()
    
    @StateObject static var emptySearchVM : SearchViewModel = {
        let vm = SearchViewModel()
        vm.query = "Theranos"
        vm.phase = .empty
        return vm
    }()
     
    @StateObject static var loadingSearchVM: SearchViewModel = {
        let vm = SearchViewModel()
        vm.phase = .fetching
        return vm
    }()
    
    @StateObject static var errorSearchVM: SearchViewModel = {
        let vm = SearchViewModel()
        vm.phase = .failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "An Error has occured"]))
        return vm
    }()
    
    @StateObject static var appVM: AppViewModel = {
        let vm = AppViewModel()
        vm.tickers = Array(Ticker.stubs.prefix(upTo: 2))
        return vm
    }()
    
    static var quotesVM: QuotesViewModel = {
        let vm = QuotesViewModel()
        vm.quotesDict = Quote.stubsDict
        return vm
    }()
    static var previews: some View {
        Group {
            NavigationStack {
                SearchView(quotesVm: quotesVM, searchVM: stubbedSearchVM)
            }
            .searchable(text: $stubbedSearchVM.query)
            .previewDisplayName("Results")
            
            NavigationStack {
                SearchView(quotesVm: quotesVM, searchVM: emptySearchVM)
            }
            .searchable(text: $emptySearchVM.query)
            .previewDisplayName("Empty Results")
            
            NavigationStack {
                SearchView(quotesVm: quotesVM, searchVM: loadingSearchVM)
            }
            .searchable(text: $loadingSearchVM.query)
            .previewDisplayName("Loading State")
            
            NavigationStack {
                SearchView(quotesVm: quotesVM, searchVM: errorSearchVM)
            }
            .searchable(text: $errorSearchVM.query)
            .previewDisplayName("Error State")
            
        }.environmentObject(appVM)
    }
}
