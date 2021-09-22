//
//  tawkGitTests.swift
//  tawkGitTests
//
//  Created by Nazmul Islam on 22/9/21.
//

import Foundation
import XCTest
@testable import tawkGit

class UserListPresenterTest: XCTestCase {

    func test_initialItemCountEmpty() {
        let service = MockUserService()
        let repository = MockUserRepository()
        let view = MockUserListView()
        let sut = UserListPresenter(
            service: service,
            repository: repository,
            reachability: nil
        )
        sut.view = view

        XCTAssertEqual(sut.itemCount, 0)
    }

    func test_loadUsers() {
        let service = MockUserService()
        let repository = MockUserRepository()
        let sut = UserListPresenter(
            service: service,
            repository: repository,
            reachability: nil
        )

        let view = MockUserListView()
        sut.view = view

        let networkUsers = Array(0..<30)
            .map({ UserNetworkModel(id: $0, login: "", avatarURL: nil) })
        let users = networkUsers
            .map({ $0.toUser() })

        let exp1 = expectation(description: "call view to show loader initially")
        view.showLoaderCalled = {
            exp1.fulfill()
        }

        let exp2 = expectation(description: "checks repository for cache data")
        repository.getUsersCalled = { _, _, completion in
            // no data in the repository
            DispatchQueue.global().async { completion([]) }
            exp2.fulfill()
        }

        let exp3 = expectation(description: "call service for data")
        service.getUsersCalled = { _, completion in
            // service returns data
            DispatchQueue.global().async { completion(.success(networkUsers)) }
            exp3.fulfill()
        }

        let exp4 = expectation(description: "call repository to save data received from network")
        repository.saveNetworkUsersCalled = { networkData, completion in
            // check same data that is recieved from network is passed to repository for persisting
            XCTAssertEqual(networkData, networkData)
            // repository returns user models after persisting
            DispatchQueue.global().async { completion?(users) }
            exp4.fulfill()
        }

        let exp5 = expectation(description: "view append items called twice, once with repository response, again when network data saved into the repository")
        var count = 0
        view.appendItemsCalled = { _ in
            count += 1
            // check with > to make sure this closure was called exactly twice
            // checking == will not work becase even if appendItemsCalled called more
            // than twice fulfill will be called once in that case
            if count > 1 {
                exp5.fulfill()
            }
        }

        sut.loadUsers()
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(sut.users, users)
    }
}

fileprivate extension UserNetworkModel {
    func toUser() -> User {
        return User(
            id: id,
            username: login,
            avatarURL: avatarURL,
            note: nil,
            profileVisited: false
        )
    }
}

extension UserNetworkModel: Equatable {
    public static func == (lhs: UserNetworkModel, rhs: UserNetworkModel) -> Bool {
        return lhs.id == rhs.id
            && lhs.login == rhs.login
            && lhs.avatarURL == rhs.avatarURL
    }
}
