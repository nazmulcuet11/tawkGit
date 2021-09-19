//
//  DownloadTaskOperation.swift
//  tawkGit
//
//  Created by Nazmul Islam on 19/9/21.
//

import Foundation

class DownloadTaskOperation: AsyncOperation {
    typealias Completion =  (URL?, URLResponse?, Error?) -> Void

    let session: URLSession
    let remoteURL: URL
    let completion: Completion

    init(
        session: URLSession,
        remoteURL: URL,
        completion: @escaping Completion
    ) {
        self.session = session
        self.remoteURL = remoteURL
        self.completion = completion

        super.init()
    }

    override func main() {
        let task = session.downloadTask(with: remoteURL) {
            [weak self]  localFileURL, response, error in
            guard let self = self else { return }

            self.completion(localFileURL, response, error)
            self.state = .finished
        }
        task.resume()
    }
}
