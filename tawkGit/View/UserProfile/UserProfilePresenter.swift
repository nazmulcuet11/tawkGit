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
    func update(profile: UserProfile)
}

class UserProfilePresenter {
    weak var view: UserProfileView?

    private let service: UserService
    private let repository: UserRepository
    private let username: String
    private var userProfile: UserProfile?
    
    init(
        service: UserService,
        repository: UserRepository,
        username: String
    ) {
        self.service = service
        self.repository = repository
        self.username = username
    }

    func viewLoaded() {
        DispatchQueue.main.async {
            self.view?.showNoDataView()
            self.view?.showLoader()
        }

        repository.getUserProfile(login: username) {
            [weak self] userProfile in
            guard let self = self,
                  let userProfile = userProfile
            else {
                return
            }

            self.userProfile = userProfile
            DispatchQueue.main.async {
                self.view?.update(profile: userProfile)
            }
        }

        service.getUserProfile(login: username) {
            [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.view?.hideLoader()
            }

            switch result {
                case .success(let networkProfile):
                    let userProfile = networkProfile.toUserProfile()
                    self.userProfile = userProfile
                    self.repository.saveUserProfile(userProfile)
                    DispatchQueue.main.async {
                        self.view?.update(profile: userProfile)
                    }
                case .failure(let error):
                    print("Error fetching data: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.view?.showNoDataView()
                    }
            }
        }
    }
}
