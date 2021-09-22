//
//  UserProfilePresenter.swift
//  tawkGit
//
//  Created by Nazmul Islam on 20/9/21.
//

import Foundation

protocol UserProfileView: AnyObject {
    func showNoDataView()
    func showLoader()
    func hideLoader()
    func update(user: User, profile: UserProfile)
}

class UserProfilePresenter {
    weak var view: UserProfileView?

    private let service: UserService
    private let repository: UserRepository
    private let user: User
    private let reachability: Reachability?

    private var userProfile: UserProfile?
    
    init(
        service: UserService,
        repository: UserRepository,
        user: User,
        reachability: Reachability?
    ) {
        self.service = service
        self.repository = repository
        self.user = user
        self.reachability = reachability

        setupReachability()
    }

    deinit {
        print("deinit \(self.self)")
    }

    func loadData() {

        user.profileVisited = true
        repository.saveUser(user)

        DispatchQueue.main.async {
            self.view?.showNoDataView()
            self.view?.showLoader()
        }

        repository.getUserProfile(login: user.username) {
            [weak self] userProfile in
            guard let self = self,
                  self.userProfile == nil,
                  let userProfile = userProfile
            else {
                return
            }

            self.userProfile = userProfile
            DispatchQueue.main.async {
                self.view?.hideLoader()
                self.view?.update(user: self.user, profile: userProfile)
            }
        }

        service.getUserProfile(login: user.username) {
            [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.view?.hideLoader()
            }

            switch result {
                case .success(let networkProfile):
                    self.processNetworkProfile(networkProfile)
                case .failure(let error):
                    print("Error fetching data: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        if self.userProfile == nil {
                            self.view?.showNoDataView()
                        }
                    }
            }
        }
    }

    func saveNote(note: String?) {
        if let note = note, !note.isEmpty {
            user.note = note
        } else {
            user.note = nil
        }
        repository.saveUser(user)
    }

    // MARK: - Helpers

    private func processNetworkProfile(_ networkModel: UserProfileNetworkModel) {
        repository.saveUserProfile(networkModel) {
            [weak self] userProfile in
            guard let self = self,
                  let userProfile = userProfile
            else {
                return
            }

            DispatchQueue.main.async {
                self.userProfile = userProfile
                self.view?.update(user: self.user, profile: userProfile)
            }
        }
    }

    private func setupReachability() {
        do {
            reachability?.whenReachable = {
                [weak self] reachability in
                guard let self = self else { return }
                if self.userProfile == nil {
                    self.loadData()
                }
            }

            try reachability?.startNotifier()
        } catch {
            print("Unable to setup Reachability")
        }
    }
}
