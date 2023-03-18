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
        VStack(alignment: .leading,spacing: 0) {
            headerView.padding(.horizontal)
            Divider()
                .padding(.vertical, 8)
                .padding(.horizontal)
        }
        .padding(.top)
        .background(Color(uiColor: .systemBackground))
        
        
    }
    
    private var headerView: some View {
        HStack(alignment: .lastTextBaseline) {
            Text(quoteVM.ticker.symbol).font(.title.bold())
            if let shortname = quoteVM.ticker.shortname {
                Text(shortname)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(Color(uiColor: .secondaryLabel))
            }
            Spacer()
            closeButton
        }
    }
        private var closeButton: some View {
            Button{
                dismiss()}
        label: {
                Circle()
                    .frame(width: 36, height: 36)
                    .foregroundColor(.gray.opacity(0.1))
                    .overlay {
                        Image(systemName: "xmark")
                            .font(.system(size: 18).bold())
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                    }
            }
            .buttonStyle(.plain)
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
