//
//  AppDelegate.swift
//  MovieBrowser
//
//  Created by Shivam Kapur on 08/11/17.
//  Copyright © 2017 ShivamKapur. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        setupRootVC()
        return true
    }
    
    private func setupRootVC()
    {
        window = UIWindow(frame: UIScreen.main.bounds)
        let movieFeedVC = MovieFeedVC()
        let navCon = UINavigationController(rootViewController: movieFeedVC)
        window?.rootViewController = navCon
        window?.makeKeyAndVisible()
    }
}

