//
//  UserListViewModel.swift
//  tawkGit
//
//  Created by Nazmul Islam on 18/9/21.
//

import Foundation

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

    private let service: UserService
    private let repository: UserRepository
    private let reachability: Reachability?

    private(set) var users = [User]()
    private(set) var filteredUsers = [User]()

    private let fetchLimit = 30

    private var lastUserId: Int { users.last?.id ?? 0 }

    init(
        service: UserService,
        repository: UserRepository,
        reachability: Reachability?
    ) {
        self.service = service
        self.repository = repository
        self.reachability = reachability

        setupReachability()
    }

    deinit {
        print("deinit \(self.self)")
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

            self.processUsersFromRepository(users)
        }

        service.getUsers(since: lastUserId) {
            [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.view?.hideLoader()
            }

            switch result {
                case .success(let networkUsers):
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

    private func setupReachability() {
        do {
            reachability?.whenReachable = {
                [weak self] reachability in
                guard let self = self else { return }
                if self.users.isEmpty {
                    self.loadUsers()
                }
            }

            try reachability?.startNotifier()
        } catch {
            print("Unable to setup Reachability")
        }
    }

    private func processNetworkUsers(_ networkUsers: [UserNetworkModel]) {

        repository.saveNetworkUsers(networkUsers) {
            [weak self] users in
            self?.processUsersFromRepository(users)
        }
    }

    private func processUsersFromRepository(_ fetchedUsers: [User]) {
        DispatchQueue.main.async {
            [weak self] in
            guard let self = self else { return }

            var indicesToReload = [Int]()
            var newUsers = [User]()

            for user in fetchedUsers {
                if let index = self.users.firstIndex(of: user) {
                    self.users[index] = user
                    indicesToReload.append(index)
                } else {
                    newUsers.append(user)
                }
            }

            self.view?.reloadItems(at: indicesToReload)
            self.users.append(contentsOf: newUsers)
            self.view?.appendItems(newItems: newUsers)
        }
    }

    enum Mode {
        case normal
        case search
    }
}
