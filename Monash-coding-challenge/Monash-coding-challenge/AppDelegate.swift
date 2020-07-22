//
//  AppDelegate.swift
//  Monash-coding-challenge
//
//  Created by Joshua on 22/7/20.
//  Copyright © 2020 Joshua. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    /// InfoViewController instance with an InfoManager initialized by default
    let infoViewController: InfoViewController = {
        return InfoViewController(manager: InfoManager())
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Use a UIHostingController as window root view controller.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: infoViewController) // assign it as the root of the navigationController, then assign the navigationController as the root of the window
        window?.makeKeyAndVisible()
        
        return true
    }
}

