//
//  ViewController.swift
//  tawkGit
//
//  Created by Nazmul Islam on 17/9/21.
//

import UIKit

class UserListVC: BaseViewController {

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
        searchController.searchBar.scopeButtonTitles = SearchMode.allCases.map({ $0.title })
        searchController.searchBar.selectedScopeButtonIndex = SearchMode.contains.rawValue
        searchController.delegate = self
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
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Users"
        navigationController?.navigationBar.prefersLargeTitles = true

        setupUI()

        tableView.registerCell(UserCell.self)
        tableView.registerCell(NoteUserCell.self)

        tableView.dataSource = self
        tableView.delegate = self

        searchController.searchResultsUpdater = self

        presenter.loadUsers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
        return presenter.itemCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = presenter.item(at: indexPath.row)

        // tell presenter that user reached last item
        if indexPath.row + 1 == presenter.itemCount {
            presenter.reachedLastItem()
        }

        return item.cell(for: tableView, at: indexPath)
    }
}

extension UserListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = presenter.item(at: indexPath.row)
        item.slected(on: self, in: tableView, at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UserListVC: UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        presenter.startSearching()
    }

    func didDismissSearchController(_ searchController: UISearchController) {
        presenter.stopSearching()
    }
}

extension UserListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchScopeIndex = searchController.searchBar.selectedScopeButtonIndex
        guard let searchTerm = searchController.searchBar.text else { return }
        guard let searchMode = SearchMode(rawValue: searchScopeIndex) else { return }
        presenter.search(searchTerm: searchTerm, searchMode: searchMode)
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

    func reloadItems(at indices: [Int]) {
        let indexPathsToReload = indices.map({ IndexPath(row: $0, section: 0) })
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }

    func appendItems(newItems: [TableViewItem]) {
        let oldCount = presenter.itemCount - newItems.count
        let newIndexPaths = Array(oldCount..<presenter.itemCount)
            .map({ IndexPath(row: $0, section: 0) })

        tableView.insertRows(at: newIndexPaths, with: .automatic)
    }
}
