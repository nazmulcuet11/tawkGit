//
//  AppDelegate.swift
//  tawkGit
//
//  Created by Nazmul Islam on 17/9/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var factory: AppFactory?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let factory = AppFactory()
        self.factory = factory

        let window = UIWindow()
        let userListVC = factory.getUserListVC()
        window.rootViewController = NavigationController(rootViewController: userListVC)
        window.makeKeyAndVisible()

        self.window = window

        return true
    }

    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        factory?.imageLoader.clearCache()
    }
}

extension UIApplication {
    static var appDelegate: AppDelegate {
        guard let appDelegate = shared.delegate as? AppDelegate else {
            fatalError("appDelegate not found")
        }
        return appDelegate
    }
}
