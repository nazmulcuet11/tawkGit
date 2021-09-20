//
//  Media.swift
//  tawkGit
//
//  Created by Nazmul Islam on 18/9/21.
//

import Foundation

class Media {
    var remoteURL: URL
    var localName: String

    init(
        remoteURL: URL,
        localName: String
    ) {
        self.remoteURL = remoteURL
        self.localName = localName
    }

    convenience init?(
        remoteURLStr: String,
        localName: String
    ) {
        guard let remoteURL = URL(string: remoteURLStr) else {
            return nil
        }

        self.init(
            remoteURL: remoteURL,
            localName: localName
        )
    }
}
