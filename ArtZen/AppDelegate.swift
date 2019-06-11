//
//  AppDelegate.swift
//  ArtZen
//
//  Created by Kevin Jackson on 6/3/19.
//  Copyright © 2019 Kevin Jackson. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var stateController = StateController()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let tabVC = window?.rootViewController as! UITabBarController
        let explorationNavVC = tabVC.viewControllers![0] as! UINavigationController
        let explorationVC = explorationNavVC.topViewController as! ExplorationViewController
        explorationVC.stateController = stateController
        
        return true
    }
}
