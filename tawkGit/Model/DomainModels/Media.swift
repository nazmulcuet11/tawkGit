//
//  Media.swift
//  tawkGit
//
//  Created by Nazmul Islam on 18/9/21.
//

import Foundation

class Media {
    var remoteURL: URL
    var localPath: String?
    var thumbLocalPath: String?

    init(
        remoteURL: URL,
        localPath: String? = nil,
        thumbLocalPath: String? = nil
    ) {
        self.remoteURL = remoteURL
        self.localPath = localPath
        self.thumbLocalPath = thumbLocalPath
    }

    convenience init?(
        remoteURLStr: String,
        localPath: String? = nil,
        thumbLocalPath: String? = nil
    ) {
        guard let remoteURL = URL(string: remoteURLStr) else {
            return nil
        }

        self.init(
            remoteURL: remoteURL,
            localPath: localPath,
            thumbLocalPath: thumbLocalPath
        )
    }
}
