//
//  UserRepository.swift
//  tawkGit
//
//  Created by Nazmul Islam on 18/9/21.
//

import Foundation

protocol UserRepository {
    typealias Completion<T> = (T) -> Void

    func getAllUsers(completion: @escaping Completion<[User]>)
    func getUsers(since: Int, limit: Int, completion: @escaping Completion<[User]>)
    func getUser(id: Int, completion: @escaping Completion<User?>)
    func saveUser(_ user: User, completion: Completion<Bool>?)
    func saveUsers(_ users: [User], completion: Completion<Bool>?)
    func saveNetworkUser(_ networkModel: UserNetworkModel, completion: Completion<User?>?)
    func saveNetworkUsers(_ networkModels: [UserNetworkModel], completion: Completion<[User]>?)
    func saveUserProfile(_ userProfile: UserProfile, completion: Completion<Bool>?)
    func getUserProfile(login: String, completion: @escaping Completion<UserProfile?>)
    func searchUsers(searchTerm: String, searchMode: SearchMode, completion: @escaping Completion<[User]>)
}

extension UserRepository {
    func saveUser(_ user: User, completion: Completion<Bool>? = nil) {
        saveUser(user, completion: completion)
    }

    func saveUsers(_ users: [User], completion: Completion<Bool>? = nil) {
        saveUsers(users, completion: completion)
    }

    func saveNetworkUser(_ networkModel: UserNetworkModel, completion: Completion<User?>? = nil) {
        saveNetworkUser(networkModel, completion: completion)
    }

    func saveNetworkUsers(_ networkModels: [UserNetworkModel], completion: Completion<[User]>? = nil) {
        saveNetworkUsers(networkModels, completion: completion)
    }


    func saveUserProfile(_ userProfile: UserProfile, completion: Completion<Bool>? = nil) {
        saveUserProfile(userProfile, completion: completion)
    }
}
