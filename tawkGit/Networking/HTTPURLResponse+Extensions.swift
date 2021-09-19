//
//  HTTPURLResponse+Extension.swift
//  tawkGit
//
//  Created by Nazmul Islam on 19/9/21.
//

import Foundation

extension HTTPURLResponse {
    private enum StatusCodes {
        static let acceptableStatusCodes = (200 ... 299)
        static let unauthorizedStatusCodes = [401, 422]
    }

    var hasAcceptableStatusCode: Bool {
        StatusCodes.acceptableStatusCodes.contains(statusCode)
    }
}
