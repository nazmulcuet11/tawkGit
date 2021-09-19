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
        let service = BackEndUserService(
            baseURL: AppConfig.GithubAPI.baseURL,
            client: HTTPClient()
        )
        let repository = CoreDataUserRepository()
        let presenter = UserListPresenter(
            service: service,
            repository: repository
        )
        let userListVC = UserListVC(presenter: presenter)
        presenter.view = userListVC
        
        window.rootViewController = NavigationController(rootViewController: userListVC)
        window.makeKeyAndVisible()

        self.window = window

        return true
    }

}

