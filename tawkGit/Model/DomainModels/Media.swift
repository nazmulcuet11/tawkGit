//
//  Media.swift
//  tawkGit
//
//  Created by Nazmul Islam on 18/9/21.
//

import Foundation

class Media {
    var remoteURL: URL
    var localURL: URL

    init(
        remoteURL: URL,
        localURL: URL
    ) {
        self.remoteURL = remoteURL
        self.localURL = localURL
    }

    convenience init?(
        remoteURLStr: String,
        localURL: URL
    ) {
        guard let remoteURL = URL(string: remoteURLStr) else {
            return nil
        }

        self.init(
            remoteURL: remoteURL,
            localURL: localURL
        )
    }
}
