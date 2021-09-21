//
//  PromtView.swift
//  tawkGit
//
//  Created by Nazmul Islam on 21/9/21.
//

import UIKit

class PromtView: UIView {
    lazy var promtLabel: UILabel = {
        let label =  UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()

    var promt: String? = nil {
        didSet {
            promtLabel.text = promt
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        addSubview(promtLabel)
        backgroundColor = .systemOrange

        NSLayoutConstraint.activate([
            promtLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            promtLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            promtLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            promtLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
        ])
    }
}
