//
//  FetchPhase.swift
//  stockgrid
//
//  Created by Le Bon B' Bauma on 15/03/2023.
//

import Foundation


enum FetchPase<V> {
    
    case initial
    case fetching
    case success(V)
    case failure(Error)
    case empty
    
    
    var value: V? {
        if case .success(let v) = self {
            return V
        }
        return nil
    }
    
    var error: Error? {
        if case .failure(let error) = self {
            return error
        }
        return nil
    }
    
    
}
