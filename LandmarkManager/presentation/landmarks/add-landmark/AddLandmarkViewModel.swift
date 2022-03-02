//
//  AddLandmarkViewModel.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 16/02/2022.
//

import Foundation
import MapKit

@MainActor class AddLandmarkViewModel: ObservableObject {
    @Published var landmarkToEdit: LandmarkModel?
    @Published var categories: [CategoryModel] = []
    @Published var selectedCategoryIndex: Int = 0
    @Published var chosenLocation: LandmarkLocation? = nil
    @Published var error: ErrorDisplayWrapper?

    private var locationManager = LocationManager.shared
        
    init(landmarkToEdit: LandmarkModel?) {
        self.landmarkToEdit = landmarkToEdit
        fetchCategories()
    }
    
    func addOrEditLandmark(name: String, description: String, image: UIImage) -> Bool {
        let edit = !(self.landmarkToEdit == nil)
        
        if name == "" {
            error = ErrorDisplayWrapper.specificError(LandmarkError.emptyName)
            return false
        } else if description == "" {
            error = ErrorDisplayWrapper.specificError(LandmarkError.emptyDescription)
            return false
        }
        
        guard let latitude = chosenLocation?.coordinates.latitude,
              let longitude = chosenLocation?.coordinates.longitude
        else {
            error = ErrorDisplayWrapper.specificError(LandmarkError.emptyLocation)
            return false
        }
        
        let coordinate = CoordinateModel(lat: latitude, lng: longitude)
           
        do {
            if edit {
                guard var landmarkToEdit = landmarkToEdit else {
                    return false
                }

                landmarkToEdit.title = name
                landmarkToEdit.desc = description
                landmarkToEdit.image = image
                landmarkToEdit.location = coordinate
                landmarkToEdit.category = categories[selectedCategoryIndex]
                try LandmarkRepository.shared.editLandmark(editedLandamrk: landmarkToEdit)
            } else {
                try LandmarkRepository.shared.addLandmark(name: name, description: description, image: image, coordinate: coordinate, category: categories[selectedCategoryIndex])
            }
            
            return true
        } catch {
            self.error = ErrorDisplayWrapper.specificError(error)
            return false
        }
    }
    
    func getAddressForLandmarkToEdit(finished: @escaping (String) -> ()) {
        let unknownAddressText = "newLandmarkList_unknownAddress".localized

        guard let landmarkToEdit = landmarkToEdit else {
            finished(unknownAddressText)
            return
        }
        
        LocationManager.shared.getAddressFromCoordinates(with: landmarkToEdit.mapSimpleLocation) { addresses in
            guard let address = addresses.first else {
                self.error = ErrorDisplayWrapper.specificError(LandmarkLocationError.locationNotFound)
                finished(unknownAddressText)
                return
            }
            
            self.error = nil
                        
            finished(address)
        }
    }
    
    private func fetchCategories() {
        categories = CategoryRepository.shared.categories.enumerated().map({ (index, category) in
            Mapper.shared.mapCategoryDbEntityToModel(entity: category, id: index)
        })
        
        guard let selectedCategory = CategoryRepository.shared.selectedCategoryId else {
            return
        }
        
        let index = categories.firstIndex { category in
            category.objectId == selectedCategory
        }
        
        selectedCategoryIndex = index ?? 0
    }
    
}
