//
//  UserCellViewModel+TableViewItem.swift
//  tawkGit
//
//  Created by Nazmul Islam on 21/9/21.
//

import UIKit

extension UserCellViewModel: TableViewItem {
    func slected(on vc: UIViewController, in tableView: UITableView, at indexPath: IndexPath) {
        guard let factory = UIApplication.appDelegate.factory else {
            return
        }

        let userProfileVC = factory.getUserProfileVC(user: user)
        vc.navigationController?.pushViewController(userProfileVC, animated: true)
    }

    func cell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell: UserCell
        if hasNote {
            cell = tableView.dequeueReusableCell(NoteUserCell.self, for: indexPath)
        } else {
            cell = tableView.dequeueReusableCell(UserCell.self, for: indexPath)
        }

        cell.configure(with: self)
        return cell
    }
}
