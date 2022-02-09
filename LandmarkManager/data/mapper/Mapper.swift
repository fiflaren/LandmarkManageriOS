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
    
    func mapCategoryDbEntityToModel(entity: Category, id: Int) -> CategoryModel {
        var landmarks = [LandmarkModel]()
        
        for (index,landmarkEntity) in entity.landmarks!.allObjects.enumerated() {
            landmarks.append(mapLandmarkDbEntityToModel(entity: landmarkEntity as! Landmark, id: index))
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
        return LandmarkModel(
            id: id,
            objectId: entity.objectID,
            title: entity.title!,
            desc: entity.desc!,
            image: UIImage(data: entity.image!) ?? UIImage(),
            isFavorite: entity.isFavorite,
            creationDate: entity.creationDate!,
            modificationDate: entity.modificationDate!
        )
    }
}
