//
//  LandmarkLocationMapViewModel.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 16/02/2022.
//

import Foundation
import MapKit

enum LandmarkLocationError: Error, LocalizedError {
    case locationNotFound
    
    var errorDescription: String? {
        switch self {
        case .locationNotFound:
            return "Le lieu selectionné n'a pas pu être trouvé"
        }
    }
}

class LandmarkLocationMapViewModel: NSObject, ObservableObject {
    private let mapLatLongDistanceMeters: Double = 2000.0
    
    @Published var mapView = MKMapView()
    
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    @Published var permissionDenied: Bool = false
    
    @Published var mapType: MKMapType = .standard
    
    @Published var searchQuery: String = ""
    
    @Published var searchResults: [LandmarkLocation] = []
    
    @Published var isLoading: Bool = false
    
    @Published var error: ErrorDisplayWrapper? = nil
    
    func getSelectedLocation(finished: @escaping (LandmarkLocation?) -> ()) {
        isLoading = true
        
        MKAnnotation
        
        let selectedLocationCoordinates = mapView.centerCoordinate
        
        let locationCoordinates = CLLocation(latitude: selectedLocationCoordinates.latitude, longitude: selectedLocationCoordinates.longitude)
        
        LocationManager.shared.getAddressFromCoordinates(with: locationCoordinates) { addresses in
            guard let address = addresses.first else {
                self.error = ErrorDisplayWrapper.specificError(LandmarkLocationError.locationNotFound)
                finished(nil)
                return
            }
            
            self.error = nil
            
            let landmarkLocation = LandmarkLocation(title: address, place: nil, coordinates: selectedLocationCoordinates)
            
            finished(landmarkLocation)
        }
    }
    
    func searchWithQuery() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchQuery
        
        MKLocalSearch(request: request).start { response, error in
            guard let result = response, error == nil else { return }
            
            self.searchResults = result.mapItems.compactMap({ (item) -> LandmarkLocation? in
                return LandmarkLocation(title: item.name ?? "Unknown name", place: item.placemark, coordinates: item.placemark.coordinate)
            })
        }
    }
    
    func selectSearchResult(location: LandmarkLocation) {
        searchQuery = ""
        
        guard let coordinate = location.place?.location?.coordinate else { return }
        
        // create pin on map
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = coordinate
        pointAnnotation.title = location.title
        
        // removing old annotation if it exists
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(pointAnnotation)
        
        // zoom on selected result
        setMapRegion(region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude), latitudinalMeters: mapLatLongDistanceMeters, longitudinalMeters: mapLatLongDistanceMeters))
    }
    
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
        
        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: mapLatLongDistanceMeters, longitudinalMeters: mapLatLongDistanceMeters)
        
        setMapRegion(region: self.region)
    }
}

private extension LandmarkLocationMapViewModel {
    func setMapRegion(region: MKCoordinateRegion) {
        self.mapView.setRegion(region, animated: true)
        
        self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
    }
}
