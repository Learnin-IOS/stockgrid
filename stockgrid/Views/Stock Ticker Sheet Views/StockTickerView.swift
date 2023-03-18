//
//  StockTickerView.swift
//  stockgrid
//
//  Created by Le Bon B' Bauma on 17/03/2023.
//

import SwiftUI
import StocksAPI

struct StockTickerView: View {
    @StateObject var quoteVM: TickerQuoteViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct StockTickerView_Previews: PreviewProvider {
    
    static var tradingStubsQuoteVM: TickerQuoteViewModel  = {
        var mockAPI = MockStocksAPI()
        mockAPI.stubbedFetchQuotesCallback = {
            [Quote.stub(istrading: true)]
        }
        return TickerQuoteViewModel(ticker: .stub, stockAPI: mockAPI)
    }()
    
    static var closedStubsQuoteVM: TickerQuoteViewModel  = {
        var mockAPI = MockStocksAPI()
        mockAPI.stubbedFetchQuotesCallback = {
            [Quote.stub(istrading: false)]
        }
        return TickerQuoteViewModel(ticker: .stub, stockAPI: mockAPI)
    }()
    
    static var loadingStubsQuoteVM: TickerQuoteViewModel  = {
        var mockAPI = MockStocksAPI()
        mockAPI.stubbedFetchQuotesCallback = {
            await withCheckedContinuation{ _ in
                
            }
        }
        return TickerQuoteViewModel(ticker: .stub, stockAPI: mockAPI)
    }()
    
    static var errorStubsQuoteVM: TickerQuoteViewModel  = {
        var mockAPI = MockStocksAPI()
        mockAPI.stubbedFetchQuotesCallback = {
            throw NSError(domain: "error", code: 0, userInfo: [NSLocalizedDescriptionKey : "An Error has Occured"])
        }
        return TickerQuoteViewModel(ticker: .stub, stockAPI: mockAPI)
    }()
    static var previews: some View {
        Group {
            StockTickerView(quoteVM: tradingStubsQuoteVM)
                .previewDisplayName("Trading")
                .frame(height: 700)
            
            StockTickerView(quoteVM: closedStubsQuoteVM)
                .previewDisplayName("Closed")
                .frame(height: 700)
            
            StockTickerView(quoteVM: loadingStubsQuoteVM)
                .previewDisplayName("Loading")
                .frame(height: 700)
            
            StockTickerView(quoteVM: errorStubsQuoteVM)
                .previewDisplayName("Error")
                .frame(height: 700)
            
           
        }.previewLayout(.sizeThatFits)
        
        

    }
}
