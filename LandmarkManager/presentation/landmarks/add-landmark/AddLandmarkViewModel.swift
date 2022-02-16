//
//  AddLandmarkViewModel.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 16/02/2022.
//

import Foundation
import MapKit

@MainActor class AddLandmarkViewModel: ObservableObject {
   
    @Published var chosenCoordinates = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @Published var selectedLocation: LandmarkLocation?
    
    private var locationManager = LocationManager.shared
        
    init() {}
//    
//    func fetchAddressForLocation(query: String) {
//        locationManager.findLocations(with: query) { foundLocations in
//            
//        }
//    }
    
}
