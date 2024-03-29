//
//  UIVIew.swift
//  testProj
//
//  Created by Roman Mokh on 28.03.2024.
//

import UIKit

extension UIView {
    
    // MARK: конфигурация activity indicator
    
    // добавление UIActivityIndicatorView
    func addIndicator() {
        
        // cоздаем новый UIView для обёртки ActivityIndicator
        let containerView = UIView()
        containerView.backgroundColor = .tpLightGray
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
        containerView.tag = 1
        
        // конфигурация ActivityIndicator
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.backgroundColor = .clear
        activityIndicator.color = .black
        
        // add subViews
        self.addSubview(containerView)
        containerView.addSubview(activityIndicator)
        
        // constaints
        activityIndicator.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        containerView.snp.makeConstraints { make in
            make.center.equalTo(snp.center)
        }
        
        // animation
        activityIndicator.startAnimating()
    }
    
    // удаление UIActivityIndicatorView
    func removeIndicator() {
        
        viewWithTag(1)?.removeFromSuperview()
    }
}
