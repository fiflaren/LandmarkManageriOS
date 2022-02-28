//
//  AddLandmarkView.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 15/02/2022.
//

import SwiftUI
import MapKit

struct AddLandmarkView: View {
    @Binding var showModal: Bool
    
    @StateObject var addLandmarkViewModel: AddLandmarkViewModel = AddLandmarkViewModel()
    
    @State private var landmarkName: String = ""
    @State private var landmarkDescription: String = ""
    @State private var landmarkAddress: String = "Adresse inconnue"
    @State private var showingImagePicker = false
    @State private var landmarkImage: UIImage?
    @State private var image: Image = Image("placeholder")
    
    @FocusState private var focusedNameField: Bool
    @FocusState private var focusedDescriptionField: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Informations générales")) {
                        TextField("Titre du lieu", text: $landmarkName)
                            .focused($focusedNameField)
                        
                        ZStack(alignment: .leading) {
                            // placeholder text for the TextEditor which isn't natively supported by SwiftUI
                            if landmarkDescription.isEmpty {
                                Text("Description du lieu…")
                                    .opacity(landmarkDescription.isEmpty ? 0.25 : 1)
                            }
                            
                            TextEditor(text: $landmarkDescription)
                                .focused($focusedDescriptionField)
                        }
                    }
                    
                    Section(header: Text("Image")) {
                        VStack(alignment: .trailing, spacing: 10) {
                            Button {
                                showingImagePicker.toggle()
                            } label: {
                                Text("chooseActionTitle")
                            }
                            
                            image
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    
                    Section(header: Text("Lieu")) {
                        HStack {
                            
                            Text(landmarkAddress)
                            
                            Spacer()
                            
                            NavigationLink {
                                LandmarkLocationSearchView()
                                    .environmentObject(addLandmarkViewModel)
                            } label: {
                                
                            }
                            
                        }
                        
                    }
                    
                    Section(header: Text("Catégorie")) {
                        VStack {
                            Picker(selection: $addLandmarkViewModel.selectedCategoryIndex, label: Text(addLandmarkViewModel.categories[addLandmarkViewModel.selectedCategoryIndex].name)) {
                                ForEach(0 ..< addLandmarkViewModel.categories.count) { index in
                                    Text(addLandmarkViewModel.categories[index].name)
                                }
                            }
                            //Text(addLandmarkViewModel.categories[landmarkCategoryIndex])
                        }.padding()
                        
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(Text("newLandmarkList_title", comment: "newLandmarkList_title"))
            .toolbar(content: {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        showModal.toggle()
                    } label: {
                        //Image(systemName: "xmark")
                        Text("cancelActionTitle")
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        let addResult = addLandmarkViewModel.addLandmark(name: landmarkName, description: landmarkDescription, image: landmarkImage ?? UIImage())
                        if (addResult) {
                            showModal = false
                        }
                    } label: {
                        Text("addActionTitle")
                    }
                }
                
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button("Terminé") {
                        focusedNameField = false
                        focusedDescriptionField = false
                    }
                }
            })
            .onChange(of: landmarkImage) { _ in loadImage() }
            .onChange(of: addLandmarkViewModel.chosenLocation, perform: { location in
                landmarkAddress = location?.title ?? "Adresse inconnue"
            })
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $landmarkImage)
            }
            .alert(item: $addLandmarkViewModel.error) { error in
                Alert(title: Text("errorActionTitle"), message: Text(error.localizedDescription))
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = landmarkImage else { return }
        image = Image(uiImage: inputImage)
    }
}

struct AddLandmarkView_Previews: PreviewProvider {
    static var previews: some View {
        AddLandmarkView(showModal: .constant(true))
    }
}
