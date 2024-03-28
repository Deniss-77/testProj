//
//  UIViewController.swift
//  testProj
//
//  Created by Roman Mokh on 27.03.2024.
//

import UIKit

extension UIViewController: Identifiable {
    
    // создание универсального alert message
    
    func alert(message: String = "", title: String = "") {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(OKAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
}
