//
//  SceneDelegate.swift
//  testProj
//
//  Created by Denis Kravets on 26.03.2024.
//

import UIKit

final class SceneDelegate: UIResponder,
                           UIWindowSceneDelegate {
    
    // MARK: Properties
    
    var window: UIWindow?
    
    // MARK: Methods
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        if let windowScene = scene as? UIWindowScene {
            
            let rootViewController = MainViewConfigurator().initScene()
            let navController = UINavigationController(rootViewController: rootViewController)
            
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = navController
            window.makeKeyAndVisible()
            
            self.window = window
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }
}
