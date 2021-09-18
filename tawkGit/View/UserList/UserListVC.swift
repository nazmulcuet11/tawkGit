//
//  ViewController.swift
//  tawkGit
//
//  Created by Nazmul Islam on 17/9/21.
//

import UIKit

class UserListVC: UIViewController {

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()

    override func loadView() {
        super.loadView()
        setupUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Users"
        navigationController?.navigationBar.prefersLargeTitles = true

        tableView.registerCell(UserCell.self)
        tableView.registerCell(NoteUserCell.self)

        tableView.dataSource = self
        tableView.delegate = self

        searchController.searchResultsUpdater = self
    }

    // MARK: - Helpers

    private func setupUI() {
        view.addSubview(tableView)

        navigationItem.searchController = searchController

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension UserListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 3 == 0 {
            let cell = tableView.dequeueReusableCell(NoteUserCell.self, for: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(UserCell.self, for: indexPath)
            return cell
        }
    }
}

extension UserListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected row \(indexPath.row)")
    }
}

extension UserListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("update search result")
    }
}
