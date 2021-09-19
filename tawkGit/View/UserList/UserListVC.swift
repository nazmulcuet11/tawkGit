//
//  ViewController.swift
//  tawkGit
//
//  Created by Nazmul Islam on 17/9/21.
//

import UIKit

protocol TableViewItem {
    func cell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell
}

class UserListVC: UIViewController {

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        return tableView
    }()

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()

    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(
            x: CGFloat(0),
            y: CGFloat(0),
            width: tableView.bounds.width,
            height: CGFloat(44)
        )
        return spinner
    }()

    private var presenter: UserListPresenter

    init(
        presenter: UserListPresenter
    ) {
        self.presenter = presenter

        super.init(nibName: nil, bundle: nil)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

        presenter.loadUsers()
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
        return presenter.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = presenter.items[indexPath.row]

        // tell presenter to load more data if reached last cell
        if indexPath.row == presenter.items.count - 1 {
            presenter.loadUsers()
        }

        return item.cell(for: tableView, at: indexPath)
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

extension UserListVC: UserListView {
    func showLoader() {
        tableView.tableFooterView = spinner
    }

    func hideLoader() {
        tableView.tableFooterView = nil
    }

    func reloadItems() {
        tableView.reloadData()
    }

    func reloadItems(at indexes: [Int]) {
        let indexPathsToReload = indexes.map({ IndexPath(row: $0, section: 0) })
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }

    func appendItems(newItems: [TableViewItem]) {
        let oldCount = presenter.items.count - newItems.count
        let newIndexPaths = Array(oldCount..<presenter.items.count)
            .map({ IndexPath(row: $0, section: 0) })

        tableView.insertRows(at: newIndexPaths, with: .automatic)
    }
}
