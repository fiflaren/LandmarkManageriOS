//
//  Mapper.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 09/02/2022.
//

import Foundation
import UIKit

class Mapper {
    static let shared = Mapper()
    
    private init() {
        
    }
    
    func mapCategoryDbEntityToModel(entity: Category, id: Int, mapLandmarks: Bool) -> CategoryModel {
        var landmarks = [LandmarkModel]()
        
        if mapLandmarks, let categoryLandmarks = entity.landmarks {
            for (index,landmarkEntity) in categoryLandmarks.allObjects.enumerated() {
                landmarks.append(mapLandmarkDbEntityToModel(entity: landmarkEntity as! Landmark, id: index))
            }
        }
        
        return CategoryModel(
            id: id,
            objectId: entity.objectID,
            name: entity.name!,
            creationDate: entity.creationDate!,
            modificationDate: entity.modificationDate!,
            landmarks: landmarks
        )
    }
    
    func mapLandmarkDbEntityToModel(entity: Landmark, id: Int) -> LandmarkModel {
        var coordinateModel: CoordinateModel? = nil
        if let coordinate = entity.coordinate {
            coordinateModel = mapCoordinateDbEntityToModel(entity: coordinate)
        }
        
        var categoryModel: CategoryModel? = nil
        if let category = entity.category {
            categoryModel = mapCategoryDbEntityToModel(entity: category, id: 0, mapLandmarks: false)
        }
        
        return LandmarkModel(
            id: id,
            objectId: entity.objectID,
            title: entity.title!,
            desc: entity.desc!,
            image: UIImage(data: entity.image!) ?? UIImage(),
            isFavorite: entity.isFavorite,
            creationDate: entity.creationDate!,
            modificationDate: entity.modificationDate!,
            category: categoryModel,
            location: coordinateModel
        )
    }
    
    func mapCoordinateDbEntityToModel(entity: Coordinate) -> CoordinateModel {
        return CoordinateModel(lat: entity.latitude, lng: entity.longitude)
    }
}
