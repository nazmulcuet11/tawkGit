//
//  NoteUserCell.swift
//  tawkGit
//
//  Created by Nazmul Islam on 18/9/21.
//

import UIKit

class NoteUserCell: UserCell {
    lazy var noteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "book")
        imageView.tintColor = .black
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 20),
            imageView.widthAnchor.constraint(equalToConstant: 20),
        ])
        return imageView
    }()

    override func setupUI() {
        super.setupUI()
       containerStack.addArrangedSubview(noteImageView)
    }
}
