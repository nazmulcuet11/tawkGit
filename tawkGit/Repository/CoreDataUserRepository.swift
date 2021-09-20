//
//  CoreDataUserRepository.swift
//  tawkGit
//
//  Created by Nazmul Islam on 18/9/21.
//

import Foundation
import CoreData

class CoreDataUserRepository: UserRepository {

    private let stack: CoreDataStack

    init(stack: CoreDataStack) {
        self.stack = stack
    }

    func saveUser(_ user: User, completion: Completion<Bool>?) {
        stack.perform(on: .background) { context in
            
            self.populateUser(user, in: context)
            self.stack.saveContext()
            completion?(true)
        }
    }

    func saveUsers(_ users: [User], completion: Completion<Bool>?) {
        stack.perform(on: .background) { context in

            for user in users {
                self.populateUser(user, in: context)
            }
            self.stack.saveContext()
            completion?(true)
        }
    }

    func getAllUsers(completion: @escaping Completion<[User]>) {
        stack.perform(on: .main) { context in

            let request: NSFetchRequest<UserMO> = UserMO.fetchRequest()

            let sortDescriptor = NSSortDescriptor(key: #keyPath(UserMO.userId), ascending: true)
            request.sortDescriptors = [sortDescriptor]

            do {
                let userMOs = try context.fetch(request)
                let users = userMOs.compactMap({ $0.toUser() })
                completion(users)
            } catch {
                print(error.localizedDescription)
                completion([])
            }

        }
    }

    func getUsers(since: Int, limit: Int, completion: @escaping Completion<[User]>) {
        stack.perform(on: .main) { context in

            let request: NSFetchRequest<UserMO> = UserMO.fetchRequest()

            let predicate = NSPredicate(format: "%K > \(since)", #keyPath(UserMO.userId))
            request.predicate = predicate

            let sortDescriptor = NSSortDescriptor(key: #keyPath(UserMO.userId), ascending: true)
            request.sortDescriptors = [sortDescriptor]

            request.fetchLimit = limit

            do {
                let userMOs = try context.fetch(request)
                let users = userMOs.compactMap({ $0.toUser() })
                completion(users)
            } catch {
                print(error.localizedDescription)
                completion([])
            }
        }
    }

    func getUserProfile(login: String, completion: @escaping Completion<UserProfile?>) {
        stack.perform(on: .main) { context in

            let request: NSFetchRequest<UserMO> = UserMO.fetchRequest()

            let predicate = NSPredicate(format: "%K == %@", #keyPath(UserMO.username), login)
            request.predicate = predicate
            do {
                guard let userMO = try context.fetch(request).first else {
                    completion(nil)
                    return
                }
                let user = userMO.toUserProfile()
                completion(user)
            } catch {
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }

    func saveUserProfile(_ userProfile: UserProfile, completion: Completion<Bool>?) {
        stack.perform(on: .background) { context in

            self.populateUser(userProfile, in: context)
            self.stack.saveContext()
            completion?(true)
        }
    }

    func searchUsers(searchTerm: String, searchMode: SearchMode, completion: @escaping Completion<[User]>) {
        fatalError("Not Implemented")
    }

    // MARK: - Helpers

    private func getUserMO(id: Int, context: NSManagedObjectContext) -> UserMO? {
        let request: NSFetchRequest<UserMO> = UserMO.fetchRequest()
        let predicate = NSPredicate(format: "%K == \(id)", #keyPath(UserMO.userId))
        request.predicate = predicate

        do {
            return try context.fetch(request).first
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    private func populateUser(_ user: User, in context: NSManagedObjectContext) {
        let userMO: UserMO
        if let existingUserMO = getUserMO(id: user.id, context: context) {
            userMO = existingUserMO
        } else {
            userMO = UserMO(context: context)
        }

        userMO.userId = Int64(user.id)
        userMO.username = user.username
        userMO.avatarURL = user.avatarURL
        userMO.note = user.note
        userMO.profileVisited = user.profileVisited
    }

    private func populateUser(_ userProfile: UserProfile, in context: NSManagedObjectContext) {
        let userMO: UserMO
        if let existingUserMO = getUserMO(id: userProfile.id, context: context) {
            userMO = existingUserMO
        } else {
            userMO = UserMO(context: context)
        }

        userMO.userId = Int64(userProfile.id)
        userMO.username = userProfile.username
        userMO.avatarURL = userProfile.avatarURL
        userMO.note = userProfile.note
        userMO.followers = Int64(userProfile.followers)
        userMO.following = Int64(userProfile.following)
        userMO.name = userProfile.name
        userMO.company = userProfile.company
        userMO.blog = userProfile.blog
        userMO.location = userProfile.location
    }
}
