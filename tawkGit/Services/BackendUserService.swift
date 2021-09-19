//
//  BackendUserService.swift
//  tawkGit
//
//  Created by Nazmul Islam on 18/9/21.
//

import Foundation

class BackEndUserService: UserService {
    private let baseURL: URL
    private let client: HTTPClient

    init(
        baseURL: URL,
        client: HTTPClient
    ) {
        self.baseURL = baseURL
        self.client = client
    }

    func getUsers(since: Int, completion: @escaping Completion<[UserNetworkModel]>) {

        let request = HTTPRequest(
            url: baseURL.appendingPathComponent("users"),
            queryParams: ["since": since]
        )

        client.response(for: request, completion: completion)
    }

    func getUserProfile(login: String, completion: @escaping Completion<UserProfileNetworkModel>) {

    }
}
