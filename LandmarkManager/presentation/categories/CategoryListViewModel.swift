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
    @Published var sortBy: Int = 0 {
        didSet {
            // if the previously selected option has been tapped again
            // invert the sorting order
            // else reset it to ascending sorting
            if sortBy == oldValue {
                sortByDescending.toggle()
            } else {
                sortByDescending = false
            }
            
            fetchCategories(searchQuery: nil)
        }
    }
    @Published var sortByDescending: Bool = false
    
    private var categoryRepository = CategoryRepository.shared
    
    init() {
        fetchCategories()
    }
    
    func fetchCategories(searchQuery: String? = nil) {
        var newCategories: [CategoryModel] = []
        for (index,category) in categoryRepository.categories.enumerated() {
            newCategories.append(Mapper.shared.mapCategoryDbEntityToModel(entity: category, id: index, mapLandmarks: true))
        }
        
        self.categories = newCategories.sorted(by: { category1, category2 in
            switch ListSortingProperty.init(rawValue: sortBy) {
            case .name:
                return (category1.name < category2.name) != sortByDescending
            case .creationDate:
                return (category1.creationDate < category2.creationDate) != sortByDescending
            case .modificationDate:
                return (category1.modificationDate < category2.modificationDate) != sortByDescending
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
    
    func searchCategories(searchQuery: String) -> [CategoryModel] {
        var categoriesMatchingQuery: [CategoryModel] = []
        
        for category in categories {
            do {
                _ = try BoyerMoore(stringLiteral: category.name.lowercased()).search(pat: searchQuery.lowercased())
                categoriesMatchingQuery.append(category)
            } catch {
                continue
            }
        }
        
        return categoriesMatchingQuery
    }
}

