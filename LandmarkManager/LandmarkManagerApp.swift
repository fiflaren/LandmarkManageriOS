//
//  LandmarkManagerApp.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 09/02/2022.
//

import SwiftUI
import CoreLocation

@main
struct LandmarkManagerApp: App {
    @State private var finishedLoading: Bool = false
    
    
    private func displayMainContent() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation {
                self.finishedLoading.toggle()
            }
        }
    }
    
    private func requestLocation() {
        
    }
    
    var body: some Scene {
        WindowGroup {
            if finishedLoading {
                CategoryListView()
                
            } else {
                SplashScreenView()
                    .onAppear {
                        displayMainContent()
                    }
            }
        }
    }
}

//class LandmarkManagerAppLocationManager {
//    private var locationManager: CLLocationManager = CLLocationManager()
//
//    init() {
//        locationManager.delegate = self
//    }
//    
//    func requestLocationAccess() {
//        locationManager.requestWhenInUseAuthorization()
//    }
//}
//
//extension LandmarkManagerAppLocationManager: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedAlways {
//            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
//                if CLLocationManager.isRangingAvailable() {
//                    // do stuff
//                }
//            }
//        }
//    }
//}
