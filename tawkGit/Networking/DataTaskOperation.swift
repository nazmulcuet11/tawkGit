//
//  NetworkOperation.swift
//  tawkGit
//
//  Created by Nazmul Islam on 19/9/21.
//

import Foundation

class DataTaskOperation: AsyncOperation {
    typealias Completion =  (Data?, URLResponse?, Error?) -> Void

    let session: URLSession
    let request: URLRequest
    let decoder: JSONDecoder
    let completion: Completion

    init(
        session: URLSession,
        request: URLRequest,
        decoder: JSONDecoder,
        completion: @escaping Completion
    ) {
        self.session = session
        self.request = request
        self.decoder = decoder
        self.completion = completion

        super.init()
    }

    override func main() {
        let task = session.dataTask(with: request) {
            [weak self] data, response, error in
            guard let self = self else { return }

            self.completion(data, response, error)
            self.state = .finished
        }

        task.resume()
    }
}
