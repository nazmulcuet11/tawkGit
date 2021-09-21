//
//  UIImageView+Extension.swift
//  tawkGit
//
//  Created by Nazmul Islam on 20/9/21.
//

import UIKit

extension UIImageView {
    func setImage(with url: URL, placeholder: UIImage?, inverted: Bool = false) {
        image = placeholder

        let appDelegate = UIApplication.appDelegate
        guard let imageLoader = appDelegate.factory?.imageLoader else {
            return
        }

        imageLoader.getImage(url: url, inverted: inverted) {
            [weak self] image in

            guard let self = self,
                  let image = image
            else {
                return
            }
            
            self.image = image
        }
    }

    func setImage(with urlStr: String, placeholder: UIImage?, inverted: Bool = false) {
        image = placeholder

        guard let url = URL(string: urlStr) else {
            return
        }

        setImage(with: url, placeholder: placeholder, inverted: inverted)
    }
}
