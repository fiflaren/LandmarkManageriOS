//
//  Coordinate.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 28/02/2022.
//

import Foundation

struct CoordinateModel: Hashable, Identifiable {
    var id = UUID()
    var lat: Double
    var lng: Double
}
