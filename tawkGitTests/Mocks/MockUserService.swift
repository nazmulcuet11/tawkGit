//
//  MockUserService.swift
//  tawkGitTests
//
//  Created by Nazmul Islam on 22/9/21.
//

import Foundation
@testable import tawkGit

class MockUserService: UserService {
    var getUsersCalled: ((Int, @escaping Completion<[UserNetworkModel]>) -> Void)? = nil
    var getUserProfileCalled: ((String, @escaping Completion<UserProfileNetworkModel>) -> Void)? = nil

    func getUsers(since: Int, completion: @escaping Completion<[UserNetworkModel]>) {
        getUsersCalled?(since, completion)
    }

    func getUserProfile(login: String, completion: @escaping Completion<UserProfileNetworkModel>) {
        getUserProfileCalled?(login, completion)
    }
}
