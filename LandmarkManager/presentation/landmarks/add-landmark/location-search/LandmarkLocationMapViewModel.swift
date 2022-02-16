//
//  LandmarkLocationMapViewModel.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 16/02/2022.
//

import Foundation
import MapKit

class LandmarkLocationMapViewModel: NSObject, ObservableObject {
    @Published var mapView = MKMapView()
    
    @Published var region: MKCoordinateRegion!
    
    @Published var permissionDenied: Bool = false
    
    @Published var mapType: MKMapType = .standard
    
    func resetToUserLocation() {
        if LocationManager.shared.getAuthorizationStatus() == .authorizedWhenInUse {
            setMapRegion(region: self.region)
        } else {
            LocationManager.shared.requestLocationPermission()
        }
    }
    
    func updateMapType() {
        if (mapType == .standard) {
            mapType = .hybrid
        } else {
            mapType = .standard
        }
        
        mapView.mapType = mapType
    }

}

extension LandmarkLocationMapViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .denied:
            // Alert
            permissionDenied = true
        case .notDetermined:
            // Requesting
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            manager.requestLocation()
        default:
            ()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 2000, longitudinalMeters:2000)
        
        setMapRegion(region: self.region)
    }
}

private extension LandmarkLocationMapViewModel {
    func setMapRegion(region: MKCoordinateRegion) {
        self.mapView.setRegion(region, animated: true)
        
        self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
    }
}
