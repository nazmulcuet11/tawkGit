//
//  ImageLoader.swift
//  tawkGit
//
//  Created by Nazmul Islam on 20/9/21.
//

import UIKit

class ImageLoader {
    typealias Completion<T> = (T) -> Void

    private let mediaManager: MediaManager
    private var cache: [URL: UIImage]

    init(
        mediaManager: MediaManager
    ) {
        self.mediaManager = mediaManager
        self.cache = .init()
    }

    func getImage(url: URL, completion: @escaping Completion<UIImage?>) {
        if let image = cache[url] {
            completion(image)
            return
        }

        mediaManager.getMedia(remoteURL: url) {
            [weak self] media in

            guard let self = self,
                  let media = media,
                  let data = try? Data(contentsOf: media.localURL),
                  let image = UIImage(data: data)
            else {
                completion(nil)
                return
            }

            self.cache[url] = image

            DispatchQueue.main.async {
                completion(image)
            }
        }
    }

    func clearCache() {
        cache = .init()
    }
}
