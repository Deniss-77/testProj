//
//  MainViewRouter.swift
//  testProj
//
//  Created by Roman Mokh on 27.03.2024.
//

import UIKit

protocol MainViewRouterProtocol: AnyObject {
    func routeToDetailedViewController(with url: String)
}

final class MainViewRouter: MainViewRouterProtocol {
    
    // MARK: Properties
    
    weak var view: MainViewProtocol?
    
    // MARK: Initializer
    
    init(view: MainViewProtocol) {
        self.view = view
    }
    
    // MARK: Methods
    
    // переход на детальный экран
    func routeToDetailedViewController(with url: String) {
        
        guard let navigationController = self.view?.navController else { return }
        
        let viewController = DetailedConfigurator().initScene()
        
        viewController.viewModel?.saveUrl(url: url)
        navigationController.pushViewController(viewController, animated: true)
    }
}
