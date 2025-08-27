//
//  AppDelegate.swift
//  ReadBook
//
//  Created by Кристина Олейник on 20.08.2025.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        if let window = window {
            let navigationController = UINavigationController()
            let viewController = HomeScreenViewController()
            navigationController.viewControllers = [viewController]
            
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
        
        return true
    }
}

