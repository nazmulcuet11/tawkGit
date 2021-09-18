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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow()
        window.rootViewController = NavigationController(rootViewController: UserListVC())
        window.makeKeyAndVisible()

        self.window = window

        return true
    }

}

