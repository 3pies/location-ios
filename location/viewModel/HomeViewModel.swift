//
//  HomeViewModel.swift
//  location
//
//  Created by Daniel Ferrer on 24/11/22.
//

import SwiftUI
import Combine
import Factory
import CoreLocation

class HomeViewModel: ObservableObject {
    
    @Injected(Container.locationManager)
    private var locationManager: LocationManager
    
    @Published var location: CLLocation? = nil
    @Published var locationStatus: CLAuthorizationStatus? = nil
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    func loadLocation() {
        //Suscripción a la última posición
        locationManager.$lastLocation
            .assign(to: \.location, on: self)
            .store(in: &cancellableSet)
        
        //Suscripción al estado de los permisos
        locationManager.$locationStatus
            .assign(to: \.locationStatus, on: self)
            .store(in: &cancellableSet)
    }
    
}


#if DEBUG
class MockHomeViewModel: HomeViewModel {
    
    

}
#endif
