//
//  CoreDataMediaRepository.swift
//  tawkGit
//
//  Created by Nazmul Islam on 20/9/21.
//

import Foundation
import CoreData

class CoreDataMediaRepository: MediaRepository {
    private let stack: CoreDataStack

    init(stack: CoreDataStack) {
        self.stack = stack
    }

    func saveMedia(_ media: Media, completion: Completion<Bool>?) {
        let mediaMo: MediaMO
        if let existingMediaMO = getMediaMO(remoteURL: media.remoteURL) {
            mediaMo = existingMediaMO
        } else {
            mediaMo = MediaMO(context: stack.mainContext)
        }

        mediaMo.remoteURL = media.remoteURL.absoluteString
        mediaMo.localName = media.localName

        stack.saveContext()
    }

    func getMedia(remoteURL: URL, completion: @escaping Completion<Media?>) {
        guard let mediaMo = getMediaMO(remoteURL: remoteURL) else {
            completion(nil)
            return
        }
        completion(mediaMo.toMedia())
    }

    private func getMediaMO(remoteURL: URL) -> MediaMO? {
        let request: NSFetchRequest<MediaMO> = MediaMO.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(MediaMO.remoteURL), remoteURL.absoluteString)
        request.predicate = predicate

        do {
            return try stack.mainContext.fetch(request).first
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
