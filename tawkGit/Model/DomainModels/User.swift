//
//  User.swift
//  tawkGit
//
//  Created by Nazmul Islam on 18/9/21.
//

import Foundation

class User: Hashable {

    var id: Int
    var username: String
    var avatar: Media?
    var note: String?

    var hasNote: Bool {
        guard let note = note else {
            return false
        }
        return !note.isEmpty
    }

    init(
        id: Int,
        username: String,
        avatar: Media?,
        note: String?
    ) {
        self.id = id
        self.username = username
        self.avatar = avatar
        self.note = note
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }

    func matches(with searchTerm: String, searchMode: SearchMode) -> Bool {
        switch searchMode {
            case .contains:
                return containsMatch(with: searchTerm)
            case .precise:
                return exactMatch(with: searchTerm)
        }
    }

    private func exactMatch(with searchTerm: String) -> Bool {
        if username.lowercased() == searchTerm.lowercased() {
            return true
        }

        if let note = note, note.lowercased() == searchTerm.lowercased() {
            return true
        }

        return false
    }

    private func containsMatch(with searchTerm: String) -> Bool {
        if username.lowercased().contains(searchTerm.lowercased()) {
            return true
        }

        if let note = note, note.lowercased().contains(searchTerm.lowercased()) {
            return true
        }

        return false
    }
}
