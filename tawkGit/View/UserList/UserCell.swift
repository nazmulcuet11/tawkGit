//
//  UserCell.swift
//  tawkGit
//
//  Created by Nazmul Islam on 18/9/21.
//

import UIKit

class UserCell: UITableViewCell {

    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "person.crop.circle")
        imageView.tintColor = .systemGray
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 50),
            imageView.widthAnchor.constraint(equalToConstant: 50),
        ])
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemGray.cgColor
        return imageView
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.text = "Username"
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return label
    }()

    lazy var detailsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.text = "Details"
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return label
    }()

    lazy var labelContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(nameLabel)
        view.addSubview(detailsLabel)

        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),

            detailsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            detailsLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
        ])

        return view
    }()

    lazy var containerStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false

        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 8

        return stack
    }()

    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 4.0
        view.clipsToBounds = true

        view.addSubview(containerStack)

        NSLayoutConstraint.activate([
            containerStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            containerStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            containerStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            containerStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
        ])

        return view
    }()

    private var viewModel: UserCellViewModel?

    private var containerBackgroundColor: UIColor {
        if let vm = viewModel, vm.profileVisited {
            return .systemGray5
        }
        return .systemGray6
    }

    private var containerHighlightColor: UIColor {
        if let vm = viewModel, vm.profileVisited {
            return .systemGray4
        }
        return .systemGray5
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        setAsSelectedOrHighlighted(selected, animated: animated)
        super.setSelected(selected, animated: animated)
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        setAsSelectedOrHighlighted(highlighted, animated: animated)
        super.setHighlighted(highlighted, animated: animated)
    }

    private func setAsSelectedOrHighlighted(_ selectedOrHighlighted: Bool, animated: Bool) {
        let action: () -> Void = {
            [weak self] in
            guard let self = self else { return }
            if selectedOrHighlighted {
                self.containerView.backgroundColor = self.containerHighlightColor
            } else {
                self.containerView.backgroundColor = self.containerBackgroundColor
            }
        }

        if animated {
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                options: .curveEaseInOut,
                animations: action,
                completion: nil
            )
        } else {
            action()
        }
    }

    func setupUI() {
        selectionStyle = .none

        contentView.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])

        containerStack.addArrangedSubview(avatarImageView)
        containerStack.addArrangedSubview(labelContainerView)
    }

    func configure(with vm: UserCellViewModel) {
        self.viewModel = vm

        nameLabel.text = vm.name
        detailsLabel.text = vm.details
        
        if let avatarURL = vm.avatarURL {
            avatarImageView.setImage(
                with: avatarURL,
                placeholder: .personPlaceholder,
                inverted: vm.invertAvatarColor
            )
        } else {
            avatarImageView.image = .personPlaceholder
        }
        
        containerView.backgroundColor = containerBackgroundColor
    }
}
