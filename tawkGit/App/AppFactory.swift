//
//  AppFactory.swift
//  tawkGit
//
//  Created by Nazmul Islam on 19/9/21.
//

import Foundation

class AppFactory {

    let dataSession: URLSession
    let dataDecoder: JSONDecoder
    let networkingQueue: OperationQueue
    let fileManager: FileManager
    let httpClient: HTTPClient
    let downloadClient: DownloadClient
    let coreDataWritingQueue: DispatchQueue
    let coreDataStack: CoreDataStack
    let mediaRepository: MediaRepository
    let mediaManager: MediaManager
    let imageLoader: ImageLoader
    let userRepository: UserRepository

    init() {
        dataSession = .shared

        dataDecoder = JSONDecoder()

        networkingQueue = OperationQueue()
        networkingQueue.name = "NETWORKING_QUEUE"
        networkingQueue.maxConcurrentOperationCount = 1
        networkingQueue.qualityOfService = .background

        fileManager = .default

        httpClient = HTTPClient(
            session: dataSession,
            decoder: dataDecoder,
            queue: networkingQueue
        )

        downloadClient = DownloadClient(
            session: dataSession,
            queue: networkingQueue
        )

        coreDataWritingQueue = DispatchQueue(label: "CORE_DATA_WRITING_QUEUE")

        coreDataStack = CoreDataStack(
            modelName: AppConfig.CoreData.modelName,
            writingQueue: coreDataWritingQueue
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

        userRepository = CoreDataUserRepository(
            stack: coreDataStack
        )
    }

    func getUserListVC() -> UserListVC {
        let service = BackEndUserService(
            baseURL: AppConfig.GithubAPI.baseURL,
            client: httpClient
        )
        let presenter = UserListPresenter(
            service: service,
            repository: userRepository
        )
        let userListVC = UserListVC(presenter: presenter)
        presenter.view = userListVC

        return userListVC
    }

    func getUserProfileVC(user: User) -> UserProfileVC {
        let service = BackEndUserService(
            baseURL: AppConfig.GithubAPI.baseURL,
            client: httpClient
        )
        let presenter = UserProfilePresenter(
            service: service,
            repository: userRepository,
            user: user
        )
        let vc = UserProfileVC.instantiate()
        vc.presenter = presenter
        presenter.view = vc
        return vc
    }
}
