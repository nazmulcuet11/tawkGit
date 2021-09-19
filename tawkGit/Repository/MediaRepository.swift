//
//  MediaRepository.swift
//  tawkGit
//
//  Created by Nazmul Islam on 19/9/21.
//

import Foundation

protocol MediaRepository {
    typealias Completion<T> = (T) -> Void
    
    func saveMedia(_ media: Media, completion: Completion<Bool>?)
    func getMedia(remoteURL: URL, completion: @escaping Completion<Media?>)
}
