//
//  CategoryListViewModel.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 09/02/2022.
//

import Foundation
import CoreLocation
import CoreData

@MainActor class LandmarkDetailsViewModel: ObservableObject {
   
    @Published var landmark: LandmarkModel
    @Published var error: ErrorDisplayWrapper?
    
    init(landmark: LandmarkModel) {
        self.landmark = landmark
    }
    
    func toggleLandmarkFavorite() {
        do {
            try LandmarkRepository.shared.toggleLandmarkFavorite(landmarkId: landmark.objectId)
            landmark.isFavorite.toggle()
        } catch {
            self.error = ErrorDisplayWrapper.specificError(error)
        }
    }
}

