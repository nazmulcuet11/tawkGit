//
//  FileManager+Extension.swift
//  tawkGit
//
//  Created by Nazmul Islam on 20/9/21.
//

import Foundation

extension FileManager {
    var documentDirectory: URL {
        guard let d = urls(for: .documentDirectory, in: .userDomainMask ).first else {
            fatalError("documentDirectory not found")
        }
        return d
    }
}
