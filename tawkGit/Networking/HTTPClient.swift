//
//  HTTPClient.swift
//  tawkGit
//
//  Created by Nazmul Islam on 19/9/21.
//

import Foundation

enum HTTPMethod: String {
    case get
    case post
    case put
    case delete
}

enum HTTPContentType: String {
    case json = "application/json"
    case multipartFormData = "multipart/form-data"
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case userAgent = "User-Agent"
}

struct HTTPRequest {
    let url: URL
    let method: HTTPMethod
    let contentType: HTTPContentType
    let queryParams: [String: Encodable]?
    let headerParams: [HTTPHeaderField: String]?
    let bodyData: Data?
    let timeoutInterval: TimeInterval

    init(
        url: URL,
        method: HTTPMethod = .get,
        contentType: HTTPContentType = .json,
        queryParams: [String: Encodable]? = nil,
        headerParams: [HTTPHeaderField: String]? = nil,
        bodyData: Data? = nil,
        timeoutInterval: TimeInterval = 60
    ) {
        self.url = url
        self.method = method
        self.contentType = contentType
        self.queryParams = queryParams
        self.headerParams = headerParams
        self.bodyData = bodyData
        self.timeoutInterval = timeoutInterval
    }
}

extension HTTPRequest {
    private func queryItems(_ key: String, _ value: Any?) -> [URLQueryItem] {
        var items = [] as [URLQueryItem]
        if let dictionary = value as? [String: AnyObject] {
            for (nestedKey, value) in dictionary {
                items += queryItems("\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [AnyObject] {
            let arrKey = key
            for value in array {
                items += queryItems(arrKey, value)
            }
        } else if let value = value {
            items.append(URLQueryItem(name: key, value: "\(value)"))
        } else {
            items.append(URLQueryItem(name: key, value: nil))
        }
        return items
    }

    private func paramsToQueryItems(_ params: [String: Encodable]?) -> [URLQueryItem]? {
        guard let params = params else { return nil }
        var items = [] as [URLQueryItem]
        let keys = Array(params.keys).sorted()
        for key in keys {
            items += queryItems(key, params[key])
        }
        return items
    }

    /// Default  implementation, you can always provide your own
    func asURLRequest() -> URLRequest {
        var request: URLRequest
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
           let items = paramsToQueryItems(queryParams) {
            urlComponents.queryItems = items
            if let requestURL = urlComponents.url {
                request = URLRequest(url: requestURL)
            } else {
                request = URLRequest(url: url)
            }
        } else {
            request = URLRequest(url: url)
        }

        request.httpMethod = method.rawValue
        request.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = timeoutInterval
        if method != .get, let data = bodyData {
            request.httpBody = data
        }

        if let authHeaders = headerParams {
            for (key, value) in authHeaders {
                request.setValue(value, forHTTPHeaderField: key.rawValue)
            }
        }

        return request
    }
}

enum HTTPClientError: Error {
    case noData
    case invalidResponse
    case unauthorized
    case serverSentError(String, Int)
    case networkError(Error)
}

class HTTPClient {
    typealias Completion<T: Decodable> = (Result<T, Error>) -> Void
    typealias CompletionWrapper = () -> Void

    private let queue: OperationQueue = {
        let q = OperationQueue()
        q.name = "HTTP_NETWORKING_QUEUE"
        q.maxConcurrentOperationCount = 1
        q.qualityOfService = .background
        return q
    }()

    private let session: URLSession
    private let decoder: JSONDecoder

    init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = session
        self.decoder = decoder
    }

    func response<T: Decodable>(for httpRequest: HTTPRequest, completion: Completion<T>?) {
        let request = httpRequest.asURLRequest()

        let operation = HTTPNetworkOperation(
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


extension HTTPURLResponse {
    private enum StatusCodes {
        static let acceptableStatusCodes = (200 ... 299)
        static let unauthorizedStatusCodes = [401, 422]
    }

    var hasAcceptableStatusCode: Bool {
        StatusCodes.acceptableStatusCodes.contains(statusCode)
    }
}
