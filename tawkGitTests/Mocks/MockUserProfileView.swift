//
//  MockUserProfileView.swift
//  tawkGitTests
//
//  Created by Nazmul Islam on 22/9/21.
//

import Foundation
@testable import tawkGit

class MockUserProfileView: UserProfileView {
    var showNoDataViewCalled: (() -> Void)? = nil
    var showLoaderCalled: (() -> Void)? = nil
    var hideLoaderCalled: (() -> Void)? = nil
    var updateCalled: ((User, UserProfile) -> Void)? = nil

    func showNoDataView() {
        showNoDataViewCalled?()
    }

    func showLoader() {
        showLoaderCalled?()
    }

    func hideLoader() {
        hideLoaderCalled?()
    }

    func update(user: User, profile: UserProfile) {
        updateCalled?(user, profile)
    }
}
