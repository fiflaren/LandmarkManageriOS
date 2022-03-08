//
//  CategoryListViewModel.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 09/02/2022.
//

import Foundation

enum CategoryListSortingProperty: Int {
    case nameAsc = 0
    case nameDesc = 1
    case creationDateAsc = 2
    case creationDateDesc = 3
}


@MainActor class CategoryListViewModel: ObservableObject {
   
    @Published var categories = [CategoryModel]()
    @Published var isLoading: Bool = true
    @Published var selectedCategory: Category?
    @Published var error: ErrorDisplayWrapper?
    @Published var sortBy: Int = 0
    
    private var categoryRepository = CategoryRepository.shared
    
    init() {
        fetchCategories()
    }
    
    func fetchCategories(searchQuery: String? = nil) {
        var newCategories: [CategoryModel] = []
        for (index,category) in categoryRepository.categories.enumerated() {
            newCategories.append(Mapper.shared.mapCategoryDbEntityToModel(entity: category, id: index))
        }
        
        self.categories = newCategories.sorted(by: { category1, category2 in
            switch CategoryListSortingProperty.init(rawValue: sortBy) {
            case .nameAsc:
                return category1.name < category2.name
            case .nameDesc:
                return category1.name > category2.name
            case .creationDateAsc:
                return category1.modificationDate > category2.modificationDate
            case .creationDateDesc:
                return category1.modificationDate < category2.modificationDate
            case .none:
                return false
            }
        })
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
    
    func getCategoryLandmarks(category: CategoryModel) -> [LandmarkModel] {
        return category.landmarks
    }
}

