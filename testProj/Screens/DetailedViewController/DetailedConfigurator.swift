//
//  DetailedConfigurator.swift
//  testProj
//
//  Created by Roman Mokh on 27.03.2024.
//

import Foundation

protocol DetailedConfiguratorProtocol: AnyObject {
    func initScene() -> DetailedViewController
}

final class DetailedConfigurator: DetailedConfiguratorProtocol {
    
    func initScene() -> DetailedViewController {
        
        let viewModel = DetailedViewModel()
        let viewController = DetailedViewController()
        
        viewController.viewModel = viewModel
        
        return viewController
    }
}
