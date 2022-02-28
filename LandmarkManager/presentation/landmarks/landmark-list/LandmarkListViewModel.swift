//
//  CategoryListViewModel.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 09/02/2022.
//

import Foundation

@MainActor class LandmarkListViewModel: ObservableObject {
   
    var selectedCategory: CategoryModel
    @Published var landmarks = [LandmarkModel]()
    @Published var isLoading: Bool = true
    @Published var selectedLandmark: LandmarkModel?
    @Published var error: ErrorDisplayWrapper?
    
    private var landmarkRepository = LandmarkRepository.shared
    
    init(selectedCategory: CategoryModel) {
        self.selectedCategory = selectedCategory
        CategoryRepository.shared.selectedCategoryId = selectedCategory.objectId
        fetchLandmarks()
    }
    
    func fetchLandmarks() {
        var newLandmarks: [LandmarkModel] = []
        for (index,landmark) in landmarkRepository.landmarks.enumerated() {
            newLandmarks.append(Mapper.shared.mapLandmarkDbEntityToModel(entity: landmark, id: index))
        }
        
        self.landmarks = newLandmarks
    }
    
//    func addCategory(name: String) {
//        categoryRepository.addCategory(name: name)
//        fetchCategories()
//    }
//
//    func editCategory(categoryIndex: Int, newName: String) {
//        do {
//            try categoryRepository.editCategory(categoryIndex: categoryIndex, newName: newName)
//            fetchCategories()
//        } catch(let error) {
//            self.error = ErrorDisplayWrapper.specificError(error)
//        }
//    }
//
//    func deleteCategory(categoryIndex: Int) {
//        do {
//            try categoryRepository.deleteCategory(categoryIndex: categoryIndex)
//            fetchCategories()
//        } catch(let error) {
//            self.error = ErrorDisplayWrapper.specificError(error)
//        }
//    }
}

