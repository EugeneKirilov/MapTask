//
//  UIViewController + Extension.swift
//  MapTask
//
//  Created by Zenya Kirilov on 29.12.22.
//

import Foundation
import UIKit

extension UIViewController {
    func startAlert() {
        let alert = UIAlertController(title: "Welcome to square counter app!",
                                      message: "You can add pins on the map and square will be counted automatically.",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "I understand!", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
