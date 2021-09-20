//
//  UserListViewModel.swift
//  tawkGit
//
//  Created by Nazmul Islam on 18/9/21.
//

import UIKit

protocol UserListView: AnyObject {
    func showLoader()
    func hideLoader()
    func reloadItems()
    func reloadItems(at indexes: [Int])
    func appendItems(newItems: [TableViewItem])
}

class UserListPresenter {
    private(set) var mode: Mode = .normal

    weak var view: UserListView?

    private var service: UserService
    private var repository: UserRepository

    private(set) var users = [User]()
    private(set) var filteredUsers = [User]()

    private var fetchLimit = 30

    private var lastUserId: Int { users.last?.id ?? 0 }

    init(
        service: UserService,
        repository: UserRepository
    ) {
        self.service = service
        self.repository = repository
    }

    func startSearching() {
        mode = .search
        view?.reloadItems()
    }

    func stopSearching() {
        mode = .normal
        view?.reloadItems()
    }

    func search(searchTerm: String, searchMode: SearchMode) {
        filteredUsers = users.filter({ $0.matches(with: searchTerm, searchMode: searchMode) })
        view?.reloadItems()
    }

    func loadUsers() {

        DispatchQueue.main.async {
            self.view?.showLoader()
        }

        repository.getUsers(since: lastUserId, limit: fetchLimit) {
            [weak self] users in
            guard let self = self else { return }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.view?.hideLoader()
            }

            self.updateUserList(newUsers: users)
        }

        service.getUsers(since: lastUserId) {
            [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.view?.hideLoader()
            }

            switch result {
                case .success(let networkUsers):
                    self.fetchLimit = networkUsers.count
                    self.processNetworkUsers(networkUsers)
                case .failure(let error):
                    print("Error fetching data: \(error.localizedDescription)")
            }
        }
    }


    var itemCount: Int {
        switch mode {
            case .normal:
                return users.count
            case .search:
                return filteredUsers.count
        }
    }

    func item(at index: Int) -> TableViewItem {
        let item: TableViewItem
        switch mode {
            case .normal:
                item = users[index]
            case .search:
                item = filteredUsers[index]
        }
        return item
    }

    func reachedLastItem() {
        switch mode {
            case .normal:
                loadUsers()
            case .search:
                break
        }

    }

    // MARK: - Helpers

    private func processNetworkUsers(_ networkUsers: [UserNetworkModel]) {
        let users = networkUsers
            .map({ User(from: $0) })
        repository.saveUsers(users)
        updateUserList(newUsers: users)
    }

    private func updateUserList(newUsers: [User]) {
        DispatchQueue.main.async {
            [weak self] in
            guard let self = self else { return }

            let newUsers = newUsers
                .filter({ !self.users.contains($0) })

            self.users.append(contentsOf: newUsers)
            self.users.sort(by: { $0.id < $1.id })
            self.view?.appendItems(newItems: newUsers)
        }
    }

    enum Mode {
        case normal
        case search
    }
}
