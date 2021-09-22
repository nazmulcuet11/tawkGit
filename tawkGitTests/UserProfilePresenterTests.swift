//
//  UserProfilePresenterTests.swift
//  tawkGitTests
//
//  Created by Nazmul Islam on 22/9/21.
//

import Foundation
import XCTest
@testable import tawkGit

class UserProfilePresenterTests: XCTestCase {
    func test_loadData() {
        let service = MockUserService()
        let repository = MockUserRepository()
        let user = User(
            id: 0,
            username: "username",
            avatarURL: nil,
            note: nil,
            profileVisited: false
        )
        let sut = UserProfilePresenter(
            service: service,
            repository: repository,
            user: user,
            reachability: nil
        )

        let view = MockUserProfileView()
        sut.view = view

        let networkUserProfile = UserProfileNetworkModel(
            id: 0,
            login: "username",
            avatarURL: nil,
            followers: 0,
            following: 0,
            name: nil,
            company: nil,
            blog: nil,
            location: nil
        )
        let userProfile = networkUserProfile.toUserProfile()

        let exp1 = expectation(description: "call view to show loader initially")
        view.showLoaderCalled = {
            exp1.fulfill()
        }

        let exp2 = expectation(description: "checks repository for cache data")
        repository.getUserProfileCalled = { _, completion in
            // no data in the repository
            DispatchQueue.global().async { completion(nil) }
            exp2.fulfill()
        }

        let exp3 = expectation(description: "call service for data")
        service.getUserProfileCalled = { _, completion in
            // service returns data
            DispatchQueue.global().async { completion(.success(networkUserProfile)) }
            exp3.fulfill()
        }

        let exp4 = expectation(description: "call repository to save data received from network")
        repository.saveNetworkUserProfileCalled = { networkData, completion in
            // check same data that is recieved from network is passed to repository for persisting
            XCTAssertEqual(networkData, networkUserProfile)
            // repository returns user profile model after persisting
            DispatchQueue.global().async { completion?(userProfile) }
            exp4.fulfill()
        }

        let exp5 = expectation(description: "view update called once, since repository does not have user profile initially")
        view.updateCalled = { user, userProfile in
            exp5.fulfill()
        }

        sut.loadData()
        waitForExpectations(timeout: 1.0, handler: nil)

        // presenter stores user profile received from the process
        XCTAssertNotNil(sut.userProfile)
    }
}

fileprivate extension UserProfileNetworkModel {
    func toUserProfile() -> UserProfile {
        return UserProfile(
            id: id,
            username: login,
            avatarURL: avatarURL,
            followers: followers,
            following: following,
            name: name,
            company: company,
            blog: blog,
            location: location
        )
    }
}
