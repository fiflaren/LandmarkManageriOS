//
//  LandmarkLocatiob.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 16/02/2022.
//

import Foundation
import MapKit

struct LandmarkLocation {
    let title: String
    let coordinate: CLLocationCoordinate2D?
    let region: MKCoordinateRegion?
}
