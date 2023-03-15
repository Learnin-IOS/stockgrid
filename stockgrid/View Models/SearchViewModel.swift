//
//  SearchViewModel.swift
//  stockgrid
//
//  Created by Le Bon B' Bauma on 15/03/2023.
//

import Combine
import Foundation
import SwiftUI
import StocksAPI


@MainActor
class SearchViewModel: ObservableObject {
    
    
    @Published var query: String = ""
    @Published var phase: FetchPase<[Ticker]> = .initial
     
     
    private var trimmedQuery: String {
        query.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var tickers: [Ticker] { phase.value ?? [] }
    var error: Error?  { phase.error }
    var isSearching: Bool  { !trimmedQuery.isEmpty }
    
    var emptyListText: String {
         "Symbols not found for\n\"\(query)\""
    }
}

