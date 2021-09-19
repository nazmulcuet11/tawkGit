//
//  SearchMode.swift
//  tawkGit
//
//  Created by Nazmul Islam on 18/9/21.
//

import Foundation

enum SearchMode: Int, CaseIterable {
    case contains
    case precise

    var title: String {
        switch self {
            case .contains:
                return "Contains"
            case .precise:
                return "Exact Match"
        }
    }
}
