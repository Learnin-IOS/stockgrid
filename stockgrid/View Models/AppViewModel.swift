//
//  AppViewModel.swift
//  stockgrid
//
//  Created by Le Bon B' Bauma on 07/03/2023.
//

import Foundation
import StocksAPI
import SwiftUI


@MainActor
class AppViewModel: ObservableObject {
    
    @Published var tickers: [Ticker] = []
    
}
