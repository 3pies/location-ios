//
//  AppInjection.swift
//  location
//
//  Created by Daniel Ferrer on 24/11/22.
//

import Foundation
import Factory

extension Container {
    
    
    //ViewModels
    static let homeViewModel = Factory() {
        HomeViewModel()
    }
}
