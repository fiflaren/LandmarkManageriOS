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
    
    @StateObject var addLandmarkViewModel: AddLandmarkViewModel
    
    @State private var landmarkName: String = ""
    @State private var landmarkDescription: String = ""
    @State private var landmarkAddress: String = "Adresse inconnue"
    @State private var showingImagePicker = false
    @State private var landmarkImage: UIImage?
    @State private var image: Image = Image("placeholder")
    @State private var submitButtonText = "addActionTitle"
    @State private var shouldLoadFiedValues: Bool = true
    
    @FocusState private var focusedNameField: Bool
    @FocusState private var focusedDescriptionField: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("newLandmarkList_generalInfoTitle")) {
                        TextField("newLandmarkList_nameTitle".localized, text: $landmarkName)
                            .focused($focusedNameField)
                        
                        ZStack(alignment: .leading) {
                            // placeholder text for the TextEditor which isn't natively supported by SwiftUI
                            if landmarkDescription.isEmpty {
                                Text("newLandmarkList_descriptionTitle")
                                    .opacity(landmarkDescription.isEmpty ? 0.25 : 1)
                            }
                            
                            TextEditor(text: $landmarkDescription)
                                .focused($focusedDescriptionField)
                        }
                    }
                    
                    Section(header: Text("newLandmarkList_imageTitle")) {
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
                    
                    Section(header: Text("newLandmarkList_locationTitle")) {
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
                    
                    Section(header: Text("newLandmarkList_categoryTitle")) {
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
                        let addResult = addLandmarkViewModel.addOrEditLandmark(name: landmarkName, description: landmarkDescription, image: landmarkImage ?? UIImage())
                        if (addResult) {
                            withAnimation {
                                showModal = false
                            }
                        }
                    } label: {
                        Text(submitButtonText)
                    }
                }
                
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button("doneTitle".localized) {
                        focusedNameField = false
                        focusedDescriptionField = false
                    }
                }
            })
            .onChange(of: landmarkImage) { _ in loadImage() }
            .onChange(of: addLandmarkViewModel.chosenLocation, perform: { location in
                landmarkAddress = location?.title ?? "newLandmarkList_unknownAddress".localized
            })
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $landmarkImage)
            }
            .alert(item: $addLandmarkViewModel.error) { error in
                Alert(title: Text("errorActionTitle"), message: Text(error.localizedDescription))
            }
            .onAppear {
                if shouldLoadFiedValues {
                    setFieldValues()
                    shouldLoadFiedValues = false
                }
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = landmarkImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    private func setFieldValues() {
        // populate form fields if there is a landmark to edit
        landmarkName = addLandmarkViewModel.landmarkToEdit?.title ?? landmarkName
        landmarkDescription = addLandmarkViewModel.landmarkToEdit?.desc ?? landmarkDescription
        
        if addLandmarkViewModel.landmarkToEdit != nil {
            addLandmarkViewModel.getAddressForLandmarkToEdit(finished: { address in
                landmarkAddress = address
            })
        }
        
        landmarkImage = addLandmarkViewModel.landmarkToEdit?.image ?? landmarkImage
        image = landmarkImage != nil ? Image(uiImage: landmarkImage!) : image
        
        submitButtonText = addLandmarkViewModel.landmarkToEdit != nil ? "editActionTitle".localized : "addActionTitle".localized
    }
}

struct AddLandmarkView_Previews: PreviewProvider {
    static var previews: some View {
        AddLandmarkView(showModal: .constant(true), addLandmarkViewModel: AddLandmarkViewModel(landmarkToEdit: nil))
    }
}
