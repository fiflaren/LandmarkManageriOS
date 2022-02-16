//
//  LocationManager.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 16/02/2022.
//

import Foundation
import MapKit

class LocationManager: NSObject {
    static let shared = LocationManager()
    
    private var locationManager = CLLocationManager()
    
    private override init() {
        
    }
    
    public func findLocations(with query: String, completion: @escaping (([LandmarkLocation]) -> Void)) {
        let geocoder = CLGeocoder()
                
        geocoder.geocodeAddressString(query) { places, error in
            guard let places = places else {
                completion([])
                return
            }
            
            let models: [LandmarkLocation] = places.compactMap { place in
                var name = ""
                
                if let locationName = place.name {
                    name += locationName
                }
                
                if let adminRegion = place.administrativeArea {
                    name += ", \(adminRegion)"
                }
                
                if let locality = place.locality {
                    name += ", \(locality)"
                }
                
                if let country = place.country {
                    name += ", \(country)"
                }
                
                var region: MKCoordinateRegion? = nil
                
                if let coordinates = place.location?.coordinate {
                    region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
                }
                
                let result = LandmarkLocation(title: name,
                                              coordinate: place.location?.coordinate,
                                              region: region)
                
                return result
            }
            
            completion(models)
        }
    }
}

extension LocationManager {
    func setLocationManagerDelegate(delegate: CLLocationManagerDelegate) {
        self.locationManager.delegate = delegate
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getAuthorizationStatus() -> CLAuthorizationStatus {
        return locationManager.authorizationStatus
    }
}

class Location: ObservableObject {
    @Published var isAuthorized: Bool? = nil
    
    func updateAuthentication(success: Bool) {
        isAuthorized = success
    }
}

