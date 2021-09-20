//
//  Config.swift
//  tawkGit
//
//  Created by Nazmul Islam on 19/9/21.
//

import Foundation

struct AppConfig {
    struct GithubAPI {
        static let baseURL = URL(string: "https://api.github.com/")!
    }

    struct CoreData {
        static let modelName = "tawk_git"
    }
}
