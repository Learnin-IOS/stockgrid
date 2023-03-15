//
//  stockgrid.swift
//  stockgrid
//
//  Created by Le Bon B' Bauma on 03/03/2023.
//

import SwiftUI

@main
struct stockgrid: App {
    @StateObject var appVM = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainListView()
            }
            .environmentObject(appVM)
        }
    }
}
