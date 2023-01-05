//
//  AppInjection.swift
//  location
//
//  Created by Daniel Ferrer on 24/11/22.
//

import Foundation
import Factory

extension Container {
    
    //Services
    static let configurationService = Factory(scope: .singleton) {
        Configuration()
    }
    
    static let appState = Factory(scope: .singleton) {
        AppState(configuration: configurationService())
    }
    
    static let locationManager = Factory(scope: .singleton) {
        LocationManager()
    }
    
    //ViewModels
    static let homeViewModel = Factory() {
        HomeViewModel()
    }
    
    //Repositories
    static let locationsRepository = Factory() {
        LocationsRepository(appState: appState())
    }
}
