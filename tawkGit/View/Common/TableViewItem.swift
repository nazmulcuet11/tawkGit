//
//  TableViewItem.swift
//  tawkGit
//
//  Created by Nazmul Islam on 21/9/21.
//

import UIKit

protocol TableViewItem {
    func slected(on vc: UIViewController, in tableView: UITableView, at indexPath: IndexPath)
    func cell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell
}
