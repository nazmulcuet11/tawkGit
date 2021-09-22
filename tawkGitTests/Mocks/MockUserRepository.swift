//
//  MockUserRepository.swift
//  tawkGitTests
//
//  Created by Nazmul Islam on 22/9/21.
//

import Foundation
@testable import tawkGit

class MockUserRepository: UserRepository {
    var getAllUsersCalled: ((@escaping Completion<[User]>) -> Void)? = nil
    var getUsersCalled: ((Int, Int, @escaping Completion<[User]>) -> Void)? = nil
    var getUserCalled: ((Int, @escaping Completion<User?>) -> Void)? = nil
    var saveUserCalled: ((User, Completion<Bool>?) -> Void)? = nil
    var saveUsersCalled: (([User], Completion<Bool>?) -> Void)? = nil
    var saveNetworkUserCalled: ((UserNetworkModel, Completion<User?>?) -> Void)? = nil
    var saveNetworkUsersCalled: (([UserNetworkModel], Completion<[User]>?) -> Void)? = nil
    var saveUserProfileCalled: ((UserProfile, Completion<Bool>?) -> Void)? = nil
    var getUserProfileCalled: ((String, @escaping Completion<UserProfile?>) -> Void)? = nil
    var searchUsersCalled: ((String, SearchMode, @escaping Completion<[User]>) -> Void)? = nil

    func getAllUsers(completion: @escaping Completion<[User]>) {
        getAllUsersCalled?(completion)
    }

    func getUsers(since: Int, limit: Int, completion: @escaping Completion<[User]>) {
        getUsersCalled?(since, limit, completion)
    }

    func getUser(id: Int, completion: @escaping Completion<User?>) {
        getUserCalled?(id, completion)
    }

    func saveUser(_ user: User, completion: Completion<Bool>?) {
        saveUserCalled?(user, completion)
    }

    func saveUsers(_ users: [User], completion: Completion<Bool>?) {
        saveUsersCalled?(users, completion)
    }

    func saveNetworkUser(_ networkModel: UserNetworkModel, completion: Completion<User?>?) {
        saveNetworkUserCalled?(networkModel, completion)
    }

    func saveNetworkUsers(_ networkModels: [UserNetworkModel], completion: Completion<[User]>?) {
        saveNetworkUsersCalled?(networkModels, completion)
    }

    func saveUserProfile(_ userProfile: UserProfile, completion: Completion<Bool>?) {
        saveUserProfileCalled?(userProfile, completion)
    }

    func getUserProfile(login: String, completion: @escaping Completion<UserProfile?>) {
        getUserProfileCalled?(login, completion)
    }

    func searchUsers(searchTerm: String, searchMode: SearchMode, completion: @escaping Completion<[User]>) {
        searchUsersCalled?(searchTerm, searchMode, completion)
    }
}
