//
//  CoreDataMediaRepository.swift
//  tawkGit
//
//  Created by Nazmul Islam on 20/9/21.
//

import Foundation

class CoreDataMediaRepository: MediaRepository {
    private var medias = [URL: Media]()

    func saveMedia(_ media: Media, completion: Completion<Bool>?) {
        medias[media.remoteURL] = media
        completion?(true)
    }

    func getMedia(remoteURL: URL, completion: @escaping Completion<Media?>) {
        completion(medias[remoteURL])
    }
}
