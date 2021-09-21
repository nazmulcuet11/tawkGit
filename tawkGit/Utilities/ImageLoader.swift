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
    private var cachedImages: [URL: UIImage]
    private var invertedImages: [URL: UIImage]
    

    init(
        mediaManager: MediaManager
    ) {
        self.mediaManager = mediaManager
        self.cachedImages = .init()
        self.invertedImages = .init()
    }

    func getImage(url: URL, inverted: Bool, completion: @escaping Completion<UIImage?>) {

        // lookup in the cache first
        if inverted {
            if let image = invertedImages[url] {
                completion(image)
                return
            }
        } else {
            if let image = cachedImages[url] {
                completion(image)
                return
            }
        }

        mediaManager.getMedia(remoteURL: url) {
            media in

            guard let media = media else {
                completion(nil)
                return
            }

            let localURL = self.mediaManager.localFileURL(for: media)

            guard let data = try? Data(contentsOf: localURL) else {
                completion(nil)
                return
            }

            DispatchQueue.main.async {
                [weak self] in

                guard let self = self,
                      let image = UIImage(data: data)
                else {
                    completion(nil)
                    return
                }
                
                self.cachedImages[url] = image
                if inverted {
                    let invertedImage = ImageFilter.invertedImage(image)
                    self.invertedImages[url] = invertedImage
                    completion(invertedImage)
                } else {
                    completion(image)
                }
            }
        }
    }

    func clearCache() {
        cachedImages = .init()
        invertedImages = .init()
    }
}
