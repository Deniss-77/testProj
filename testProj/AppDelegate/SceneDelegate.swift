//
//  SceneDelegate.swift
//  testProj
//
//  Created by Denis Kravets on 26.03.2024.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: Properties
    
    var window: UIWindow?
    
    // MARK: Methods
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        if let windowScene = scene as? UIWindowScene {
            
            let navController = UINavigationController(rootViewController: MainViewConfigurator().initScene())
            
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = navController
            self.window = window
            window.makeKeyAndVisible()
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
