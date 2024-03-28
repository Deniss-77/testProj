//
//  UIVIew.swift
//  testProj
//
//  Created by Roman Mokh on 28.03.2024.
//

import UIKit

extension UIView {
    
    // добавление UIActivityIndicatorView
    func addActivityIndicator() {
        
        // cоздаем новый UIView для обертки ActivityIndicator
        let containerView = UIView()
        containerView.backgroundColor = .customLightGray
        containerView.layer.cornerRadius = 10
        containerView.tag = 1
        containerView.layer.masksToBounds = true
        
        // cоздаем и настраиваем ActivityIndicator
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.backgroundColor = .clear
        activityIndicator.color = .black
        activityIndicator.startAnimating()
        
        // add subViews
        self.addSubview(containerView)
        containerView.addSubview(activityIndicator)
        
        // constaints
        activityIndicator.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        containerView.snp.makeConstraints { make in
            make.center.equalTo(self.snp.center)
        }
    }
    
    // удаление UIActivityIndicatorView
    func removeActivityIndicator() {
        
        viewWithTag(1)?.removeFromSuperview()
    }
}
