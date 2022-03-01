//
//  Landmark.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 09/02/2022.
//

import Foundation
import UIKit
import CoreData
import CoreLocation

struct LandmarkModel: Hashable, Identifiable {
    var id: Int
    var objectId: NSManagedObjectID
    var title: String
    var desc: String
    var image: UIImage
    var isFavorite: Bool
    var creationDate: Date
    var modificationDate: Date
    var category: CategoryModel?
    var location: CoordinateModel?
    
    var mapLocation: CLLocationCoordinate2D {
        guard let location = location else {
            return CLLocationCoordinate2D.init()
        }

        return CLLocationCoordinate2D(latitude: location.lat, longitude: location.lng)
    }
    
    var landmarkLocation: LandmarkLocation {
        return LandmarkLocation(title: self.title, place: nil, coordinates: self.mapLocation)
    }
}
