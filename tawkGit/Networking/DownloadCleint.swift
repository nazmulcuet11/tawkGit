//
//  DownloadCleint.swift
//  tawkGit
//
//  Created by Nazmul Islam on 19/9/21.
//

import Foundation

enum DownloadClientError: Error {
    case noData
    case invalidResponse
    case serverSentError(String, Int)
}

class DownloadClient {
    typealias Completion = (Result<URL, Error>) -> Void

    private let session: URLSession
    private let queue: OperationQueue

    init(
        session: URLSession,
        queue: OperationQueue
    ) {
        self.session = session
        self.queue = queue
    }

    func download(url remoteURL: URL, completion: @escaping Completion) {
        let operation = DownloadTaskOperation(
            session: session,
            remoteURL: remoteURL
        ) {
            localURL, response, error in

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let response = response as? HTTPURLResponse else {
                completion(.failure(DownloadClientError.invalidResponse))
                return
            }

            guard response.hasAcceptableStatusCode else {
                completion(.failure(DownloadClientError.serverSentError(response.description, response.statusCode)))
                return
            }

            guard let localURL = localURL else {
                completion(.failure(DownloadClientError.noData))
                return
            }

            completion(.success(localURL))
        }
        queue.addOperation(operation)
    }
}
