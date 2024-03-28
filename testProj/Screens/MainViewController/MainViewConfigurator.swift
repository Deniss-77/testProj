//
//  MainViewConfigurator.swift
//  testProj
//
//  Created by Roman Mokh on 27.03.2024.
//

import Foundation

protocol MainViewConfiguratorProtocol: AnyObject {
    func initScene() -> MainViewController
}

final class MainViewConfigurator: MainViewConfiguratorProtocol {
    
    func initScene() -> MainViewController {
        
        let viewController = MainViewController()
        
        let router = MainViewRouter(view: viewController)
        let viewModel = MainViewModel(router: router)
        let collectionDirector = MainViewCollectionDirector(viewModel: viewModel)
        
        viewModel.collectionDirector = collectionDirector
        viewController.viewModel = viewModel

        return viewController
    }
}
