//
//  AddLandmarkView.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 15/02/2022.
//

import SwiftUI

struct AddLandmarkView: View {
    @Binding var showModal: Bool
    @State private var landmarkName: String = ""
    @State private var landmarkDescription: String = ""
    @State private var showingImagePicker = false
    @State private var landmarkImage: UIImage?
    @State private var image: Image = Image("placeholder")
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    showModal.toggle()
                } label: {
                    Image(systemName: "xmark")
                }

                Spacer()
                
                Text("test")
                    .multilineTextAlignment(.center)
                    .font(.title2)
                
                Spacer()
            }
            .padding()
            
            Form {
                Section(header: Text("Informations générales")) {
                    TextField("Titre du lieu", text: $landmarkName)
                    
                    TextView(text: $landmarkDescription, textStyle: .constant(UIFont.TextStyle.body))
                }
                
                Section(header: Text("Image")) {
                    VStack(alignment: .trailing, spacing: 10) {
                        Button {
                            showingImagePicker.toggle()
                        } label: {
                            Text("Changer")
                        }

                        image
                            .resizable()
                            .scaledToFit()
                    }
                    
                }
            }
        }
        .navigationTitle(Text("newLandmarkList_title", comment: "newLandmarkList_title"))
        .onChange(of: landmarkImage) { _ in loadImage() }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $landmarkImage)
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
