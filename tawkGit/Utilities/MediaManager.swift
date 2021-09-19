//
//  MediaManager.swift
//  tawkGit
//
//  Created by Nazmul Islam on 19/9/21.
//

import Foundation

class MediaManager {
    typealias Completion<T> = (T) -> Void

    private let downloadClient: DownloadClient
    private let fileManager: FileManager
    private let mediaRepository: MediaRepository

    init(
        downloadClient: DownloadClient,
        fileManager: FileManager,
        mediaRepository: MediaRepository
    ) {
        self.downloadClient = downloadClient
        self.fileManager = fileManager
        self.mediaRepository = mediaRepository
    }

    func getMedia(remoteURL: URL, completion: @escaping Completion<Media?>) {
        mediaRepository.getMedia(remoteURL: remoteURL) {
            [weak self] media in
            guard let self = self else { return }

            // if available in local storage return immidiately
            if let media = media {
                completion(media)
                return
            }

            self.downloadClient.download(url: remoteURL) {
                result in

                switch result {
                    case .success(let tempLocalURL):
                        do {
                            // copy media to document directory
                            guard let documentDir = self.fileManager.urls(
                                for: .documentDirectory,
                                in: .userDomainMask
                            ).first else {
                                completion(nil)
                                return
                            }

                            let mediaDir = documentDir
                                .appendingPathComponent("media")

                            if !self.fileManager.fileExists(atPath: mediaDir.path) {
                                try self.fileManager.createDirectory(
                                    at: mediaDir,
                                    withIntermediateDirectories: true,
                                    attributes: nil
                                )
                            }

                            let fileName = UUID().uuidString
                            let fileURL = mediaDir
                                .appendingPathComponent(fileName)

                            try self.fileManager.moveItem(at: tempLocalURL, to: fileURL)

                            // create new media
                            let media = Media(remoteURL: remoteURL, localURL: fileURL)

                            // store media as cache
                            self.mediaRepository.saveMedia(media) {
                                success in

                                if success {
                                    completion(media)
                                } else {
                                    completion(nil)
                                }
                            }
                        } catch {
                            print(error)
                            completion(nil)
                        }
                    case .failure(let error):
                        print(error)
                        completion(nil)
                }
            }
        }
    }
}
