//
//  MockUserListView.swift
//  tawkGitTests
//
//  Created by Nazmul Islam on 22/9/21.
//

import Foundation
@testable import tawkGit

class MockUserListView: UserListView {

    var showLoaderCalled: (() -> Void)? = nil
    var hideLoaderCalled: (() -> Void)? = nil
    var reloadItemsCalled: (() -> Void)? = nil
    var reloadItemsAtIndicesCalled: (([Int]) -> Void)? = nil
    var appendItemsCalled: (([TableViewItem]) -> Void)? = nil

    func showLoader() {
        showLoaderCalled?()
    }

    func hideLoader() {
        hideLoaderCalled?()
    }

    func reloadItems() {
        reloadItemsCalled?()
    }

    func reloadItems(at indices: [Int]) {
        reloadItemsAtIndicesCalled?(indices)
    }

    func appendItems(newItems: [TableViewItem]) {
        appendItemsCalled?(newItems)
    }
}
