//
//  AppDelegate.swift
//  Movies
//
//  Created by Yves Bastos on 08/07/2018.
//  Copyright © 2018 Yves Bastos. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        initialSetup()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        window?.rootViewController = loadRootScreen()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) { }

    func applicationDidEnterBackground(_ application: UIApplication) { }

    func applicationWillEnterForeground(_ application: UIApplication) { }

    func applicationDidBecomeActive(_ application: UIApplication) { }

    func applicationWillTerminate(_ application: UIApplication) { }

    // MARK: - Util
    private func initialSetup() {
        TMDbManager.shared.getConfiguration()
    }
    
    private func loadRootScreen() -> UIViewController {
        let moviesListViewController = MoviesListViewController()
        let navigationController = UINavigationController(rootViewController: moviesListViewController)
        
        return navigationController
    }
}
