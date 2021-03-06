//
//  UserProfileVC.swift
//  tawkGit
//
//  Created by Nazmul Islam on 20/9/21.
//

import UIKit

class UserProfileVC: BaseViewController, StoryboardBased {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var noDataLabel: UILabel!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var blogLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var notesTextViewHeightLC: NSLayoutConstraint!
    @IBOutlet weak var footerViewHeightLC: NSLayoutConstraint!

    var presenter: UserProfilePresenter!

    private var keyboardHeight: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 75
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.borderColor = UIColor.systemGray.cgColor

        notesTextView.delegate = self
        notesTextView.clipsToBounds = true
        notesTextView.layer.cornerRadius = 4
        notesTextView.layer.borderWidth = 1
        notesTextView.layer.borderColor = UIColor.systemGray.cgColor

        saveButton.clipsToBounds = true
        saveButton.layer.cornerRadius = 4
        saveButton.backgroundColor = .systemGray
        saveButton.isEnabled = false

        addObservers()

        presenter.loadData()
    }

    deinit {
        removeObservers()
    }

    @IBAction func didTapSaveButton(_ sender: UIButton) {
        presenter.saveNote(note: notesTextView.text)
        saveButton.backgroundColor = .systemGray
        saveButton.isEnabled = false
        notesTextView.resignFirstResponder()
    }

    @IBAction func didTapOnView(_ sender: Any) {
        notesTextView.resignFirstResponder()
    }

    private func resizeTextView() {
        let size = CGSize(width: notesTextView.bounds.width, height: .infinity)
        let estimatedSize = notesTextView.sizeThatFits(size)
        let heightToSet: CGFloat
        if estimatedSize.height > 120 {
            heightToSet = estimatedSize.height
        } else {
            heightToSet = 120
        }

        let currentHeight = notesTextViewHeightLC.constant
        let diff = heightToSet - currentHeight
        notesTextViewHeightLC.constant = heightToSet

        var newOffset = scrollView.contentOffset
        newOffset.y += diff
        scrollView.setContentOffset(newOffset, animated: false)
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyBoardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyBoardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }

    @objc
    private func keyBoardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = keyboardAnimationDuration(userInfo),
              let frame = keyboardFrame(userInfo)
        else {
            return
        }

        keyboardHeight = frame.height
        UIView.animate(withDuration: duration) {
            self.footerViewHeightLC.constant = frame.height + 1
        }
    }

    @objc
    private func keyBoardWillHide(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = keyboardAnimationDuration(userInfo)
        else {
            return
        }

        UIView.animate(withDuration: duration) {
            self.footerViewHeightLC.constant = 1
        }
    }

    private func keyboardAnimationDuration(_ userInfo: [AnyHashable : Any]) -> TimeInterval? {
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else {
            return nil
        }

        return TimeInterval(truncating: duration)
    }

    private func keyboardFrame(_ userInfo: [AnyHashable : Any]) -> CGRect? {
        guard let v = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return nil
        }
        return v.cgRectValue
    }
}

extension UserProfileVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        resizeTextView()
        saveButton.backgroundColor = .label
        saveButton.isEnabled = true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        var point = view.frame.origin
        let textViewFrame = view.convert(notesTextView.frame, from: notesTextView)
        point.y = textViewFrame.maxY - (UIScreen.main.bounds.height - keyboardHeight)
        scrollView.setContentOffset(point, animated: true)
    }
}

extension UserProfileVC: UserProfileView {
    func showNoDataView() {
        noDataLabel.isHidden = false
        noDataView.isHidden = false
    }

    func showLoader() {
        noDataLabel.isHidden = true
        activityIndicator.isHidden = false
    }

    func hideLoader() {
        noDataLabel.isHidden = false
        activityIndicator.isHidden = true
    }

    func update(user: User, profile: UserProfile) {
        noDataView.isHidden = true

        title = profile.username

        if let avatarURL = profile.avatarURL {
            avatarImageView.setImage(
                with: avatarURL,
                placeholder: .personPlaceholder
            )
        } else {
            avatarImageView.image = .personPlaceholder
        }

        followersLabel.text = "Followers: \(profile.followers)"
        followingLabel.text = "Following: \(profile.following)"

        if let name = profile.name {
            nameLabel.text = "Name: \(name)"
        } else {
            nameLabel.isHidden = true
        }

        if let company = profile.company {
            companyLabel.text = "Company: \(company)"
        } else {
            companyLabel.isHidden = true
        }

        if let blog = profile.blog {
            blogLabel.text = "Blog: \(blog)"
        } else {
            blogLabel.isHidden = true
        }

        if let location = profile.location {
            locationLabel.text = "Location: \(location)"
        } else {
            locationLabel.isHidden = true
        }

        if let note = user.note {
            notesTextView.text = note
        } else {
            notesTextView.text = nil
        }

        resizeTextView()
    }
}
