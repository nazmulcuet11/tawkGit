//
//  UserRepository.swift
//  tawkGit
//
//  Created by Nazmul Islam on 18/9/21.
//

import Foundation

protocol UserRepository {
    typealias Completion<T> = (T) -> Void

    func saveUser(_ user: User, completion: Completion<Bool>?)
    func saveUsers(_ users: [User], completion: Completion<Bool>?)
    func getUsers(since: Int, limit: Int, completion: @escaping Completion<[User]>)
    func getUserProfile(login: String, completion: @escaping Completion<UserProfile?>)
    func searchUsers(searchTerm: String, searchMode: SearchMode, completion: @escaping Completion<[User]>)
}
