//
//  AppFactory.swift
//  tawkGit
//
//  Created by Nazmul Islam on 19/9/21.
//

import Foundation

class AppFactory {

    let fileManager: FileManager
    let imageLoader: ImageLoader
    let mediaManager: MediaManager
    let mediaRepository: MediaRepository
    let userService: UserService
    let userRepository: UserRepository

    init() {
        let dataSession: URLSession = .shared

        let dataDecoder = JSONDecoder()

        let networkingQueue = OperationQueue()
        networkingQueue.name = "NETWORKING_QUEUE"
        networkingQueue.maxConcurrentOperationCount = 1
        networkingQueue.qualityOfService = .background

        fileManager = .default

        let httpClient = HTTPClient(
            session: dataSession,
            decoder: dataDecoder,
            queue: networkingQueue
        )

        let downloadClient = DownloadClient(
            session: dataSession,
            queue: networkingQueue
        )

        let coreDataStack = CoreDataStack(
            modelName: AppConfig.CoreData.modelName
        )

        mediaRepository = CoreDataMediaRepository(
            stack: coreDataStack
        )

        mediaManager = MediaManager(
            downloadClient: downloadClient,
            fileManager: fileManager,
            mediaRepository: mediaRepository
        )

        imageLoader = ImageLoader(
            mediaManager: mediaManager
        )

        userService = BackEndUserService(
            baseURL: AppConfig.GithubAPI.baseURL,
            client: httpClient
        )

        userRepository = CoreDataUserRepository(
            stack: coreDataStack
        )
    }

    func getUserListVC() -> UserListVC {
        var reachability: Reachability?
        do {
            reachability = try Reachability()
        } catch {
            print("Can not create reachability: \(error.localizedDescription)")
        }

        let presenter = UserListPresenter(
            service: userService,
            repository: userRepository,
            reachability: reachability
        )
        let userListVC = UserListVC(presenter: presenter)
        presenter.view = userListVC

        return userListVC
    }

    func getUserProfileVC(user: User) -> UserProfileVC {
        var reachability: Reachability?
        do {
            reachability = try Reachability()
        } catch {
            print("Can not create reachability: \(error.localizedDescription)")
        }

        let presenter = UserProfilePresenter(
            service: userService,
            repository: userRepository,
            user: user,
            reachability: reachability
        )
        let vc = UserProfileVC.instantiate()
        vc.presenter = presenter
        presenter.view = vc
        return vc
    }
}
