//
//  Config.swift
//  tawkGit
//
//  Created by Nazmul Islam on 19/9/21.
//

import Foundation

// TODO: should be loaded from a json

struct AppConfig {
    struct GithubAPI {
        static let baseURL = URL(string: "https://api.github.com/")!
    }
}
