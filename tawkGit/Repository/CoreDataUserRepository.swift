//
//  CoreDataUserRepository.swift
//  tawkGit
//
//  Created by Nazmul Islam on 18/9/21.
//

import Foundation

class CoreDataUserRepository: UserRepository {

    private var users = [User]()
    private var queue = DispatchQueue(label: "CORE_DATA", qos: .background)

    func saveUser(_ user: User, completion: Completion<Bool>?) {
        queue.asyncAfter(deadline: .now() + 1) {
            if !self.users.contains(user) {
                self.users.append(user)
                self.users.sort(by: { $0.id < $1.id })
            }
            completion?(true)
        }
    }

    func saveUsers(_ users: [User], completion: Completion<Bool>?) {
        queue.asyncAfter(deadline: .now() + 1) {
            let newUsers = users
                .filter({ !self.users.contains($0) })
            self.users.append(contentsOf: newUsers)
            self.users.sort(by: { $0.id < $1.id })
            completion?(true)
        }
    }

    func getUsers(since: Int, limit: Int, completion: @escaping Completion<[User]>) {
        queue.asyncAfter(deadline: .now() + 1) {
            let filteredUsers = self.users
                .filter({ $0.id > since })
                .prefix(limit)
            completion(Array(filteredUsers))
        }
    }

    func getUserProfile(login: String, completion: @escaping Completion<UserProfile?>) {

    }

    func searchUsers(searchTerm: String, searchMode: SearchMode, completion: @escaping Completion<[User]>) {

    }
}
