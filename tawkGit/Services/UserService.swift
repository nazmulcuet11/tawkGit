//
//  UserService.swift
//  tawkGit
//
//  Created by Nazmul Islam on 18/9/21.
//

import Foundation

protocol UserService {
    typealias Completion<T> = (Result<T, Error>) -> Void

    func getUsers(since: Int, completion: @escaping Completion<[UserNetworkModel]>)
    func getUserProfile(login: String, completion: @escaping Completion<UserProfileNetworkModel>)
}
