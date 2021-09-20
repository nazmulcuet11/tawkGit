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

    var mediaDir: URL {
        return fileManager
            .documentDirectory
            .appendingPathComponent("media")
    }

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
                            if !self.fileManager.fileExists(atPath: self.mediaDir.path) {
                                try self.fileManager.createDirectory(
                                    at: self.mediaDir,
                                    withIntermediateDirectories: true,
                                    attributes: nil
                                )
                            }

                            // create new media
                            let fileName = UUID().uuidString
                            let media = Media(remoteURL: remoteURL, localName: fileName)
                            let localURL = self.localFileURL(for: media)

                            try self.fileManager.moveItem(at: tempLocalURL, to: localURL)

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

    func localFileURL(for media: Media) -> URL {
        return mediaDir
            .appendingPathComponent(media.localName)
    }
}
