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

    func getAllUsers(completion: @escaping Completion<[User]>) {
        stack.perform { context in

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
        stack.perform { context in

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

    func getUser(id: Int, completion: @escaping Completion<User?>) {

        stack.perform { context in
            guard let userMo = self.getUserMO(id: id, context: context) else {
                completion(nil)
                return
            }
            completion(userMo.toUser())
        }
    }

    func saveUser(_ user: User, completion: Completion<Bool>?) {
        stack.perform { context in

            self.populateUser(user, in: context)
            self.stack.saveContext()
            completion?(true)
        }
    }

    func saveUsers(_ users: [User], completion: Completion<Bool>?) {
        stack.perform { context in

            for user in users {
                self.populateUser(user, in: context)
            }
            self.stack.saveContext()
            completion?(true)
        }
    }

    func saveNetworkUser(_ networkModel: UserNetworkModel, completion: Completion<User?>?) {
        stack.perform { context in
            let userMO = self.populateUser(networkModel, in: context)
            self.stack.saveContext()
            completion?(userMO.toUser())
        }
    }

    func saveNetworkUsers(_ networkModels: [UserNetworkModel], completion: Completion<[User]>?) {
        stack.perform { context in
            var users = [User]()
            for model in networkModels {
                let userMO = self.populateUser(model, in: context)
                if let user = userMO.toUser() {
                    users.append(user)
                }
            }
            self.stack.saveContext()
            completion?(users)
        }
    }

    func getUserProfile(login: String, completion: @escaping Completion<UserProfile?>) {
        stack.perform { context in

            guard let userProfileMO = self.getUserProfileMO(login: login, context: context) else {
                completion(nil)
                return
            }

            let user = userProfileMO.toUserProfile()
            completion(user)
        }
    }

    func saveUserProfile(_ userProfile: UserProfile, completion: Completion<Bool>?) {
        stack.perform { context in
            self.populateUserProfile(userProfile, in: context)
            self.stack.saveContext()
            completion?(true)
        }
    }

    func saveNetworkUserProfile(_ networkModel: UserProfileNetworkModel, completion: Completion<UserProfile?>?) {
        stack.perform { context in
            let userProfileMO = self.populateUserProfile(networkModel, in: context)
            self.stack.saveContext()
            completion?(userProfileMO.toUserProfile())
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

    private func getUserProfileMO(login: String, context: NSManagedObjectContext) -> UserProfileMO? {
        let request: NSFetchRequest<UserProfileMO> = UserProfileMO.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(UserProfileMO.username), login)
        request.predicate = predicate

        do {
            return try context.fetch(request).first
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    @discardableResult
    private func populateUser(_ user: User, in context: NSManagedObjectContext) -> UserMO {
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

        return userMO
    }

    @discardableResult
    private func populateUser(_ networkModel: UserNetworkModel, in context: NSManagedObjectContext) -> UserMO {
        let userMO: UserMO
        if let existingUserMO = getUserMO(id: networkModel.id, context: context) {
            userMO = existingUserMO
        } else {
            userMO = UserMO(context: context)
        }

        userMO.userId = Int64(networkModel.id)
        userMO.username = networkModel.login
        userMO.avatarURL = networkModel.avatarURL
        return userMO
    }

    @discardableResult
    private func populateUserProfile(_ userProfile: UserProfile, in context: NSManagedObjectContext) -> UserProfileMO {
        let userProfileMO: UserProfileMO
        if let existingUserProfileMO = getUserProfileMO(login: userProfile.username, context: context) {
            userProfileMO = existingUserProfileMO
        } else {
            userProfileMO = UserProfileMO(context: context)
        }

        userProfileMO.userId = Int64(userProfile.id)
        userProfileMO.username = userProfile.username
        userProfileMO.avatarURL = userProfile.avatarURL
        userProfileMO.followers = Int64(userProfile.followers)
        userProfileMO.following = Int64(userProfile.following)
        userProfileMO.name = userProfile.name
        userProfileMO.company = userProfile.company
        userProfileMO.blog = userProfile.blog
        userProfileMO.location = userProfile.location

        return userProfileMO
    }

    @discardableResult
    private func populateUserProfile(_ networkModel: UserProfileNetworkModel, in context: NSManagedObjectContext) -> UserProfileMO {
        let userProfileMO: UserProfileMO
        if let existingUserProfileMO = getUserProfileMO(login: networkModel.login, context: context) {
            userProfileMO = existingUserProfileMO
        } else {
            userProfileMO = UserProfileMO(context: context)
        }

        userProfileMO.userId = Int64(networkModel.id)
        userProfileMO.username = networkModel.login
        userProfileMO.avatarURL = networkModel.avatarURL
        userProfileMO.followers = Int64(networkModel.followers)
        userProfileMO.following = Int64(networkModel.following)
        userProfileMO.name = networkModel.name
        userProfileMO.company = networkModel.company
        userProfileMO.blog = networkModel.blog
        userProfileMO.location = networkModel.location

        return userProfileMO
    }
}
