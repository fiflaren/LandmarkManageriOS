//
//  CategoryListViewModel.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 09/02/2022.
//

import Foundation

@MainActor class CategoryListViewModel: ObservableObject {
   
    @Published var categories = [CategoryModel]()
    @Published var isLoading: Bool = true
    @Published var selectedCategory: Category?
    @Published var error: ErrorDisplayWrapper?
    
    private var categoryRepository = CategoryRepository.shared
    
    init() {
        fetchCategories()
    }
    
    func fetchCategories(searchQuery: String? = nil) {
        var newCategories: [CategoryModel] = []
        for (index,category) in categoryRepository.categories.enumerated() {
            newCategories.append(Mapper.shared.mapCategoryDbEntityToModel(entity: category, id: index))
        }
        
        self.categories = newCategories
    }
    
    func addCategory(name: String) {
        categoryRepository.addCategory(name: name)
        fetchCategories()
    }
    
    func editCategory(categoryIndex: Int, newName: String) {
        do {
            try categoryRepository.editCategory(categoryIndex: categoryIndex, newName: newName)
            fetchCategories()
        } catch(let error) {
            self.error = ErrorDisplayWrapper.specificError(error)
        }
    }
    
    func deleteCategory(categoryIndex: Int) {
        do {
            try categoryRepository.deleteCategory(categoryIndex: categoryIndex)
            fetchCategories()
        } catch(let error) {
            self.error = ErrorDisplayWrapper.specificError(error)
        }
    }
}

