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
        stack.perform { context in

            let mediaMo: MediaMO
            if let existingMediaMO = self.getMediaMO(remoteURL: media.remoteURL, context: context) {
                mediaMo = existingMediaMO
            } else {
                mediaMo = MediaMO(context: context)
            }

            mediaMo.remoteURL = media.remoteURL.absoluteString
            mediaMo.localName = media.localName

            self.stack.saveContext()
            completion?(true)
        }
    }

    func getMedia(remoteURL: URL, completion: @escaping Completion<Media?>) {
        stack.perform { context in

            guard let mediaMo =  self.getMediaMO(remoteURL: remoteURL, context: context) else {
                completion(nil)
                return
            }
            completion(mediaMo.toMedia())
        }
    }

    private func getMediaMO(remoteURL: URL, context: NSManagedObjectContext) -> MediaMO? {
        let request: NSFetchRequest<MediaMO> = MediaMO.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(MediaMO.remoteURL), remoteURL.absoluteString)
        request.predicate = predicate

        do {
            return try context.fetch(request).first
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
