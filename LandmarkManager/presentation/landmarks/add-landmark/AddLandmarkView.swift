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
                        
                        TextEditor(text: $landmarkDescription)
                            .focused($focusedDescriptionField)
                        
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
                            
                            Text(addLandmarkViewModel.selectedLocation?.title ?? "Lieu non défini")
                            
                            Spacer()
                            
                            NavigationLink {
                                LandmarkLocationSearchView()
                            } label: {
                            
                            }
                            
                        }
                        
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
                        Image(systemName: "xmark")
                    }
                }
            })
            .onChange(of: landmarkImage) { _ in loadImage() }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $landmarkImage)
            }
            // to also allow swipes on items (theoretically)
            .simultaneousGesture(DragGesture().onChanged({ _ in
                focusedNameField = false
                focusedDescriptionField = false
            }))
            // dissmis on tap as well
            //        .onTapGesture {
            //            focusedNameField = false
            //        }
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
