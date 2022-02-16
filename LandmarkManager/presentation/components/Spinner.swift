//
//  Spinner.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 16/02/2022.
//

import SwiftUI

struct Spinner: UIViewRepresentable {
    
    typealias UIViewType = UIActivityIndicatorView
    
    @Binding var animate: Bool
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = UIColor.systemBackground
        return activityIndicator
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        uiView.startAnimating()
    }
}
