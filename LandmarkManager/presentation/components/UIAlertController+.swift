//
//  UIAlertController+.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 09/02/2022.
//

import Foundation

//extension UIAlertController {
//  convenience init(alert: TextAlert) {
//    self.init(title: alert.title, message: alert.message, preferredStyle: .alert)
//    addTextField {
//       $0.placeholder = alert.placeholder
//       $0.keyboardType = alert.keyboardType
//    }
//    if let cancel = alert.cancel {
//      addAction(UIAlertAction(title: cancel, style: .cancel) { _ in
//        alert.action(nil)
//      })
//    }
//    if let secondaryActionTitle = alert.secondaryActionTitle {
//       addAction(UIAlertAction(title: secondaryActionTitle, style: .default, handler: { _ in
//         alert.secondaryAction?()
//       }))
//    }
//    let textField = self.textFields?.first
//    addAction(UIAlertAction(title: alert.accept, style: .default) { _ in
//      alert.action(textField?.text)
//    })
//  }
//}
