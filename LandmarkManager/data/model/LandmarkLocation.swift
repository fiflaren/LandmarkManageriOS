//
//  LandmarkLocatiob.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 16/02/2022.
//

import Foundation
import MapKit

struct LandmarkLocation: Equatable, Identifiable {
    static func == (lhs: LandmarkLocation, rhs: LandmarkLocation) -> Bool {
        lhs.id == rhs.id && lhs.title == rhs.title
    }
    
    let id = UUID().uuidString
    let title: String
    let place: CLPlacemark?
    let coordinates: CLLocationCoordinate2D
}
