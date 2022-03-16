//
//  CategoryListView.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 09/02/2022.
//

import SwiftUI
import CoreData

struct LandmarkListView: View {
    @StateObject var landmarkViewModel: LandmarkListViewModel
    
    @State private var searchText: String = ""
    @State private var showAddLandmarkModal: Bool = false
    @State private var selectedTabIndex: Int = 0
    @State private var landmarkToEdit: LandmarkModel? = nil
    @State private var showDeleteConfirmation: Bool = false
    @State private var selection: NSManagedObjectID?
    
    private var gridColumnConfig: [GridItem] {
        Array(repeating: .init(.fixed(150)), count: 2)
    }
    
    var body: some View {
        VStack {
            if landmarkViewModel.isLoading {
                ProgressView()
            } else if landmarkViewModel.isLoading == false && landmarkViewModel.landmarks.count == 0 {
                Text("landmarkList_emptyText")
            } else {
                
                if selectedTabIndex == 0 {
                    if !favoriteSearchResults.isEmpty {
                        HStack {
                            Text("Favoris")
                                .fontWeight(.semibold)
                                .font(.title2)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 40)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(favoriteSearchResults) { landmark in
                                        NavigationLink(tag: landmark.objectId, selection: $selection) {
                                            LandmarkDetails(landmark: landmark)
                                        } label: {
                                            LandmarkGridCell(landmark: landmark, showBackgroundBlur: true)
                                        }
                                        .contextMenu {
                                            Button {
                                                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                                    landmarkViewModel.toggleLandmarkFavorite(landmarkId: landmark.objectId)
                                                    landmarkViewModel.fetchLandmarks()
                                                }
                                            } label: {
                                                Label("\(landmark.isFavorite ? "Retirer des" : "Ajouter aux ") favoris", systemImage: landmark.isFavorite ? "heart" : "heart.fill")
                                            }
                                        }
                                }
                            }
                            .padding(40)
                        }
                    }
                    
                    List {
                        Section() {
                            LandmarkListSectionContent(displayOnlyFavorites: false, landmarkToEdit: $landmarkToEdit, showAddLandmarkModal: $showAddLandmarkModal, searchText: $searchText, showDeleteConfirmation: $showDeleteConfirmation)
                                .environmentObject(landmarkViewModel)
                        }
                    }
                    .searchable(text: $searchText, prompt: "landmarkList_searchPlaceholder".localized)
                    
                    
                } else {
                    LandmarkMapView(showDetailsOnTap: true, mapLandmarks: landmarkViewModel.landmarks)
                }
            }
        }
        .navigationTitle(Text("landmarkList_title", comment: "landmarkList_title"))
        .toolbar(content: {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                LandmarkListToolbar(selectedTabIndex: $selectedTabIndex, showAddLandmarkModal: $showAddLandmarkModal)
                    .environmentObject(landmarkViewModel)
            }
        })
        .alert(item: $landmarkViewModel.error) { error in
            Alert(title: Text("errorActionTitle"), message: Text(error.localizedDescription))
        }
        .sheet(isPresented: $showAddLandmarkModal) {
            AddLandmarkView(showModal: $showAddLandmarkModal, addLandmarkViewModel: AddLandmarkViewModel(landmarkToEdit: landmarkToEdit))
        }
        .onChange(of: showAddLandmarkModal, perform: { newValue in
            if newValue == false {
                landmarkToEdit = nil
            }
            
            landmarkViewModel.fetchLandmarks()
        })
        .onAppear {
            landmarkViewModel.loadLandmarks()
        }
    }
    
    private var favoriteSearchResults: [LandmarkModel] {
        let landmarks = landmarkViewModel.getLandmarks(favorite: true)
        
        if searchText.isEmpty {
            return landmarks
        } else {
            return landmarks.filter { $0.title.contains(searchText) }
        }
    }
}

struct LandmarkListToolbar: View {
    @EnvironmentObject var landmarkViewModel: LandmarkListViewModel
    @Binding var selectedTabIndex: Int
    @Binding var showAddLandmarkModal: Bool
    
    var body: some View {
        Menu {
            Section {
                Button(action: {
                    selectedTabIndex = selectedTabIndex == 0 ? 1 : 0
                }) {
                    Label(selectedTabIndex == 0 ? "Carte" : "Liste", systemImage: selectedTabIndex == 0 ? "map" : "list.bullet")
                }
            }
            
            if selectedTabIndex == 0 {
                Section {
                    Picker(selection: $landmarkViewModel.sortBy, label: Text("Trier par")) {
                        ForEach(ListSortingProperty.allCases) { sortingProperty in
                            HStack {
                                Text(sortingProperty.description).tag(sortingProperty.id)
                                Spacer()
                                if landmarkViewModel.sortBy == sortingProperty.id {
                                    Image(systemName: landmarkViewModel.sortByDescending ? "chevron.down" : "chevron.up")
                                }
                            }
                        }
                    }
                }
            }
        }
    label: {
        Label("More", systemImage: "ellipsis.circle")
    }
        
        addButton
        
    }
    
    private var addButton: some View {
        return AnyView(
            Button {
                showAddLandmarkModal.toggle()
            } label: {
                Image(systemName: "plus")
            }
        )
    }
}

struct LandmarkListSectionContent: View {
    var displayOnlyFavorites: Bool?
    @Binding var landmarkToEdit: LandmarkModel?
    @Binding var showAddLandmarkModal: Bool
    @Binding var searchText: String
    @Binding var showDeleteConfirmation: Bool
    
    @EnvironmentObject var landmarkViewModel: LandmarkListViewModel
    @State private var selection: NSManagedObjectID?
    
    var body: some View {
        ForEach(searchResults) { landmark in
            //let index = landmarkViewModel.landmarks.firstIndex(where: { $0.objectId == landmark.objectId })!
            
            NavigationLink(tag: landmark.objectId, selection: $selection) {
                LandmarkDetails(landmark: landmark)
            } label: {
                LandmarkListRow(landmark: landmark)
                    .contextMenu {
                        Button {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                landmarkViewModel.toggleLandmarkFavorite(landmarkId: landmark.objectId)
                                landmarkViewModel.fetchLandmarks()
                            }
                        } label: {
                            Label("\(landmark.isFavorite ? "Retirer des" : "Ajouter aux ") favoris", systemImage: landmark.isFavorite ? "heart" : "heart.fill")
                        }
                    }
                
            }
            // edit swipe action
            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                Button {
                    onEdit(landmark: landmark)
                } label: {
                    Label {
                        Text("editActionTitle", comment: "editActionTitle")
                    } icon: {
                        Image(systemName: "pencil")
                    }
                }
                .tint(.accentColor)
            }
            // delete swipe action
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                    showDeleteConfirmation = true
                } label: {
                    Label {
                        Text("deleteActionTitle", comment: "deleteActionTitle")
                    } icon: {
                        Image(systemName: "trash")
                    }
                }
                .tint(.red)
            }
            // confirmation dialog on delete
            .confirmationDialog(
                "landmarkList_deleteConfirmation".localized,
                isPresented: $showDeleteConfirmation
            ) {
                Button("deleteActionTitle".localized, role: .destructive) {
                    withAnimation {
                        landmarkViewModel.deleteLandmark(landmarkId: landmark.objectId)
                    }
                }
                
                Button("cancelActionTitle".localized, role: .cancel) {}
            }
            
        }
    }
    
    private func onEdit(landmark: LandmarkModel) {
        landmarkToEdit = landmark
        showAddLandmarkModal = true
    }
    
    private var searchResults: [LandmarkModel] {
        guard let displayOnlyFavorites = displayOnlyFavorites else {
            return landmarkViewModel.landmarks
        }
        
        let landmarks = landmarkViewModel.getLandmarks(favorite: displayOnlyFavorites)
        
        if searchText.isEmpty {
            return landmarks
        } else {
            return landmarks.filter { $0.title.contains(searchText) }
        }
    }
}
