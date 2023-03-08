//
//  MainListView.swift
//  stockgrid
//
//  Created by Le Bon B' Bauma on 03/03/2023.
//

import SwiftUI
import StocksAPI

struct MainListView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct MainListView_Previews: PreviewProvider {
    static var previews: some View {
        MainListView()
    }
}
