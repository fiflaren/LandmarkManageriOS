//
//  AddLandmarkViewModel.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 16/02/2022.
//

import Foundation
import MapKit

@MainActor class AddLandmarkViewModel: ObservableObject {
   
    @Published var chosenLocation: LandmarkLocation? = nil
    
    private var locationManager = LocationManager.shared
        
    init() {}
//    
//    func fetchAddressForLocation(query: String) {
//        locationManager.findLocations(with: query) { foundLocations in
//            
//        }
//    }
    
}
