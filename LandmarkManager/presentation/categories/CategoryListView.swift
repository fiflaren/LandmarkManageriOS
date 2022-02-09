//
//  CategoryListView.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 09/02/2022.
//

import SwiftUI
import CoreData

struct CategoryListView: View {
    @StateObject var categoryViewModel: CategoryListViewModel = CategoryListViewModel()
    
    @State private var selection: NSManagedObjectID?
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationView {
            Group {
                if categoryViewModel.categories.count == 0 {
                    Text("categoryList_emptyText")
                } else {
                    List {
                        ForEach(searchResults) { category in
                            let index = categoryViewModel.categories.firstIndex(where: { $0.objectId == category.objectId })!
                            
                            NavigationLink(tag: category.objectId, selection: $selection) {
                                LandmarkListView(landmarkViewModel: LandmarkListViewModel(selectedCategory: category))
                            } label: {
                                CategoryListRow(category: category)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button {
                                    onDelete(index: index)
                                } label: {
                                    Label {
                                        Text("deleteActionTitle", comment: "deleteActionTitle")
                                    } icon: {
                                        Image(systemName: "trash")
                                    }
                                }
                                .tint(.accentColor)
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button {
                                    onEdit(index: index, name: category.name)
                                } label: {
                                    Label {
                                        Text("editActionTitle", comment: "editActionTitle")
                                    } icon: {
                                        Image(systemName: "pencil")
                                    }
                                }
                                .tint(.accentColor)
                            }
                        }
                    }
                    .searchable(text: $searchText, prompt: "Trouver une catégorie…".localized)
                }
            }
            .navigationTitle(Text("categoryList_title", comment: "categoryList_title"))
            //        .accessibilityRotor("Catégories", entries: searchResults, entryLabel: \.name)
            .navigationBarItems(trailing: addButton)
            .alert(item: $categoryViewModel.error) { error in
                Alert(title: Text("Erreur"), message: Text(error.localizedDescription))
            }
            
        }
    }
    
    private func onEdit(index: Int, name: String) {
        showAlertWithTextView(add: false, text: name) { categoryName in
            withAnimation {
                categoryViewModel.editCategory(categoryIndex: index, newName: categoryName)
            }
        }
    }
    
    private func onDelete(index: Int) {
        withAnimation {
            categoryViewModel.deleteCategory(categoryIndex: index)
        }
    }
    
    private var addButton: some View {
        return AnyView(
            Button {
                showAlertWithTextView(add: true, text: nil) { categoryName in
                    withAnimation(.spring()) {
                        categoryViewModel.addCategory(name: categoryName)
                    }
                }
            } label: {
                Image(systemName: "plus")
            }
        )
    }
    
    private var searchResults: [CategoryModel] {
        if searchText.isEmpty {
            return categoryViewModel.categories
        } else {
            return categoryViewModel.categories.filter { $0.name.contains(searchText) }
        }
    }
}

extension CategoryListView {
    private func showAlertWithTextView(add: Bool, text: String?, finished: @escaping (String) -> ()) {
        let alert = UIAlertController(title: add ? "newCategory_title".localized : "editCategory_title".localized,
                                      message: add ? "newCategory_subTitle".localized : "editCategory_subTitle".localized,
                                      preferredStyle: .alert)
        alert.addTextField { textField in
            if let text = text {
                textField.text = text
            }
            textField.placeholder = add ? "newCategory_textFieldPlaceholder".localized : "editCategory_textFieldPlaceholder".localized
        }
        
        let cancelAction = UIAlertAction(title: "cancelActionTitle".localized, style: .cancel, handler: nil)
        
        let saveAction = UIAlertAction(title: add ? "newCategory_saveActionTitle".localized : "editCategory_saveActionTitle".localized, style: .default) { _ in
            guard let textField = alert.textFields?.first else {
                return
            }
            
            finished(textField.text!)
        }
        
        
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        showAlert(alert: alert)
    }
    
    func showAlert(alert: UIAlertController) {
        if let controller = topMostViewController() {
            controller.present(alert, animated: true)
        }
    }
    
    private func keyWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter {$0.activationState == .foregroundActive}
            .compactMap {$0 as? UIWindowScene}
            .first?.windows.filter {$0.isKeyWindow}.first
    }
    
    private func topMostViewController() -> UIViewController? {
        guard let rootController = keyWindow()?.rootViewController else {
            return nil
        }
        return topMostViewController(for: rootController)
    }
    
    private func topMostViewController(for controller: UIViewController) -> UIViewController {
        if let presentedController = controller.presentedViewController {
            return topMostViewController(for: presentedController)
        } else if let navigationController = controller as? UINavigationController {
            guard let topController = navigationController.topViewController else {
                return navigationController
            }
            return topMostViewController(for: topController)
        } else if let tabController = controller as? UITabBarController {
            guard let topController = tabController.selectedViewController else {
                return tabController
            }
            return topMostViewController(for: topController)
        }
        return controller
    }
}
