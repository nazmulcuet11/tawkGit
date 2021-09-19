//
//  BackendUserService.swift
//  tawkGit
//
//  Created by Nazmul Islam on 18/9/21.
//

import Foundation

class BackEndUserService: UserService {
    private  var currentId = 0
    private var queue = DispatchQueue(label: "NETWORK", qos: .background)

    func getUsers(since: Int, completion: @escaping Completion<[UserNetworkModel]>) {
        queue.asyncAfter(deadline: .now() + 2) {
            var users = [UserNetworkModel]()
            for _ in 0..<30 {
                let user = UserNetworkModel(
                    id: self.currentId,
                    login: "user\(self.currentId + 1)",
                    avatarURL: nil
                )
                users.append(user)
                self.currentId += 1
            }
            completion(.success(users))
        }
    }

    func getUserProfile(login: String, completion: @escaping Completion<UserProfileNetworkModel>) {

    }
}
