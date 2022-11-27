//
//  LocationManager.swift
//  location
//
//  Created by Daniel Ferrer on 26/11/22.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    //Gestiona la ubicación
    private let locationManager = CLLocationManager()
    
    //Estado de autorización del usuario
    @Published var locationStatus: CLAuthorizationStatus?
    //Última posición del usuario
    @Published var lastLocation: CLLocation?
    
    override init() {
        super.init()
        //Solicitamos permiso para obtener localización
        locationManager.requestWhenInUseAuthorization()
        //Indicamos que nosotros mismo implementamos el protocolo CLLocationManagerDelegate
        locationManager.delegate = self
        //Indicamos la precisión que requerimos
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //Empezamos a obtener la ubicación
        locationManager.startUpdatingLocation()
    }
    
    
    //Notifica sobre cambios en la ubicación del usuario
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
        print(#function, location)
    }
    
    //Notifica sobre cambios en el estado de autorización
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationStatus = manager.authorizationStatus
        print(#function, statusString)
    }
    
    //Transformamos el estado a un tipo string
    private var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizationWhenInUse"
        case .authorizedAlways: return "authorizationAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}
