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
    @State private var gridMode: Bool = false
    
    private var gridColumnConfig: [GridItem] {
        Array.init(repeating: GridItem(.adaptive(minimum: 150, maximum: 250), spacing: 10, alignment: .center),
                   count: 2)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                if landmarkViewModel.isLoading {
                    ProgressView()
                } else if landmarkViewModel.isLoading == false && landmarkViewModel.landmarks.count == 0 {
                    HStack {
                        Spacer()
                        Text("landmarkList_emptyText")
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    .padding()
                    
                } else {
                    if selectedTabIndex == 0 {
                        if gridMode {
                            ScrollView(.vertical, showsIndicators: false) {
                                if landmarkViewModel.getNumberOfLandmarks(favoriteLandmarks: true) > 0 {
                                    HStack {
                                        Text("landmarkList_favoritesTitle").font(.title).fontWeight(.bold)
                                        Spacer()
                                    }
                                    .padding(10)
                                    
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack {
                                            LandmarkListSectionContent(displayOnlyFavorites: true, landmarkToEdit: $landmarkToEdit, showAddLandmarkModal: $showAddLandmarkModal, searchText: $searchText, showDeleteConfirmation: $showDeleteConfirmation, style: .grid(showBackgroundBlur: true, height: geometry.size.height / 4))
                                                .environmentObject(landmarkViewModel)
                                                .padding(.vertical, 10)
                                        }
                                        .frame(maxHeight: 150)
                                        .padding(10)
                                    }
                                    //.frame(maxHeight: geometry.size.height / 4)
                                    
                                    // if there are any non favorite landmarks display a divider
                                    if landmarkViewModel.getNumberOfLandmarks(favoriteLandmarks: false) > 0 {
                                        Divider()
                                            .padding()
                                    }
                                    
                                }
                                
                                
                                LazyVGrid(
                                    columns: gridColumnConfig,
                                    alignment: .leading,
                                    spacing: 10,
                                    pinnedViews: [.sectionHeaders, .sectionFooters]
                                ) {
                                    LandmarkListSectionContent(displayOnlyFavorites: false, landmarkToEdit: $landmarkToEdit, showAddLandmarkModal: $showAddLandmarkModal, searchText: $searchText, showDeleteConfirmation: $showDeleteConfirmation, style: .grid(showBackgroundBlur: false, height: geometry.size.height))
                                        .environmentObject(landmarkViewModel)
                                }
                                .padding(10)
                            }
                        } else {
                            List {
                                if landmarkViewModel.getNumberOfLandmarks(favoriteLandmarks: true) > 0 {
                                    Section(header: Text("landmarkList_favoritesTitle")) {
                                        LandmarkListSectionContent(displayOnlyFavorites: true, landmarkToEdit: $landmarkToEdit, showAddLandmarkModal: $showAddLandmarkModal, searchText: $searchText, showDeleteConfirmation: $showDeleteConfirmation, style: .list)
                                            .environmentObject(landmarkViewModel)
                                    }
                                }
                                
                                Section() {
                                    LandmarkListSectionContent(displayOnlyFavorites: false, landmarkToEdit: $landmarkToEdit, showAddLandmarkModal: $showAddLandmarkModal, searchText: $searchText, showDeleteConfirmation: $showDeleteConfirmation, style: .list)
                                        .environmentObject(landmarkViewModel)
                                }
                            }
                            .searchable(text: $searchText, prompt: "landmarkList_searchPlaceholder".localized)
                        }
                    } else {
                        LandmarkMapView(showDetailsOnTap: true, mapLandmarks: landmarkViewModel.landmarks)
                    }
                }
            }
        }
        .navigationTitle(Text("landmarkList_title", comment: "landmarkList_title"))
        .toolbar(content: {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                LandmarkListToolbar(selectedTabIndex: $selectedTabIndex, showAddLandmarkModal: $showAddLandmarkModal, gridMode: $gridMode)
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
}

struct LandmarkListToolbar: View {
    @EnvironmentObject var landmarkViewModel: LandmarkListViewModel
    @Binding var selectedTabIndex: Int
    @Binding var showAddLandmarkModal: Bool
    @Binding var gridMode: Bool
    
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
                    Button {
                        gridMode.toggle()
                    } label: {
                        Label(gridMode ? "Liste" : "Grille", systemImage: gridMode ? "list.bullet" : "square.grid.2x2")
                    }
                }
                
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

enum LandmarkListSectionContentDisplayStyle {
    case list
    case grid(showBackgroundBlur: Bool, height: CGFloat)
}

struct LandmarkListSectionContent: View {
    var displayOnlyFavorites: Bool?
    @Binding var landmarkToEdit: LandmarkModel?
    @Binding var showAddLandmarkModal: Bool
    @Binding var searchText: String
    @Binding var showDeleteConfirmation: Bool
    var style: LandmarkListSectionContentDisplayStyle
    @EnvironmentObject var landmarkViewModel: LandmarkListViewModel
    @State private var selection: NSManagedObjectID?
    
    var body: some View {
        ForEach(searchResults) { landmark in
            //let index = landmarkViewModel.landmarks.firstIndex(where: { $0.objectId == landmark.objectId })!
            
            NavigationLink(tag: landmark.objectId, selection: $selection) {
                LandmarkDetails(landmark: landmark)
            } label: {
                switch style {
                case .list:
                    LandmarkListRow(landmark: landmark)
                        .contextMenu {
                            toggleFavoriteButton(landmark: landmark)
                        }
                case .grid(let showBackgroundBlur, let height):
                    NavigationLink(tag: landmark.objectId, selection: $selection) {
                        LandmarkDetails(landmark: landmark)
                    } label: {
                        LandmarkGridCell(landmark: landmark, showBackgroundBlur: showBackgroundBlur)
                            .scaledToFit()
                            .frame(maxHeight: height)
                    }
                    .contextMenu {
                        toggleFavoriteButton(landmark: landmark)
                        
                        editButton(landmark: landmark)
                        
                        deleteButton(landmark: landmark)
                    }
                }
                
                
            }
            // edit swipe action
            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                editButton(landmark: landmark)
            }
            // delete swipe action
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                deleteButton(landmark: landmark)
            }
            // confirmation dialog on delete
            .confirmationDialog(
                "landmarkList_deleteConfirmation".localized,
                isPresented: $showDeleteConfirmation
            ) {
                Button("deleteActionTitle".localized, role: .destructive) {
                    withAnimation {
                        landmarkViewModel.deleteLandmark(landmarkId: nil)
                    }
                }
                
                Button("cancelActionTitle".localized, role: .cancel) {}
            }
            
        }
    }
    
    private func toggleFavoriteButton(landmark: LandmarkModel) -> some View {
        Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                landmarkViewModel.toggleLandmarkFavorite(landmarkId: landmark.objectId)
                landmarkViewModel.fetchLandmarks()
            }
        } label: {
            Label("\(landmark.isFavorite ? "Retirer des" : "Ajouter aux ") favoris", systemImage: landmark.isFavorite ? "heart" : "heart.fill")
        }
    }
    
    private func editButton(landmark: LandmarkModel) -> some View {
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
    
    private func deleteButton(landmark: LandmarkModel) -> some View {
        Button(role: .destructive) {
            print("landmarkList_deleteConfirmation".localized)
            landmarkViewModel.landmarkIdToDelete = landmark.objectId
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
