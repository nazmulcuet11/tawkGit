//
//  HTTPClient.swift
//  tawkGit
//
//  Created by Nazmul Islam on 19/9/21.
//

import Foundation

enum HTTPClientError: Error {
    case noData
    case invalidResponse
    case serverSentError(String, Int)
}

class HTTPClient {
    typealias Completion<T: Decodable> = (Result<T, Error>) -> Void
    typealias CompletionWrapper = () -> Void

    private let session: URLSession
    private let decoder: JSONDecoder
    private let queue: OperationQueue

    init(
        session: URLSession,
        decoder: JSONDecoder,
        queue: OperationQueue
    ) {
        self.session = session
        self.decoder = decoder
        self.queue = queue
    }

    func response<T: Decodable>(for httpRequest: HTTPRequest, completion: Completion<T>?) {
        let request = httpRequest.asURLRequest()

        let operation = DataTaskOperation(
            session: session,
            request: request,
            decoder: decoder
        ) {
            [weak self] data, response, error in
            guard let self = self else { return }

            if let error = error {
                completion?(.failure(error))
                return
            }

            guard let response = response as? HTTPURLResponse else {
                completion?(.failure(HTTPClientError.invalidResponse))
                return
            }

            guard response.hasAcceptableStatusCode else {
                completion?(.failure(HTTPClientError.serverSentError(response.description, response.statusCode)))
                return
            }

            guard let data = data else {
                completion?(.failure(HTTPClientError.noData))
                return
            }

            do {
                let t = try self.decoder.decode(T.self, from: data)
                completion?(.success(t))
            } catch {
                completion?(.failure(error))
            }
            
        }
        queue.addOperation(operation)
    }
}
