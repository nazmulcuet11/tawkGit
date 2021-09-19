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
    let mediaRepository: MediaRepository
    let mediaManager: MediaManager
    let imageLoader: ImageLoader

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

        mediaRepository = CoreDataMediaRepository()

        mediaManager = MediaManager(
            downloadClient: downloadClient,
            fileManager: fileManager,
            mediaRepository: mediaRepository
        )

        imageLoader = ImageLoader(
            mediaManager: mediaManager
        )
    }

    func getUserListVC() -> UserListVC {
        let service = BackEndUserService(
            baseURL: AppConfig.GithubAPI.baseURL,
            client: httpClient
        )
        let repository = CoreDataUserRepository()
        let presenter = UserListPresenter(
            service: service,
            repository: repository
        )
        let userListVC = UserListVC(presenter: presenter)
        presenter.view = userListVC

        return userListVC
    }

}
