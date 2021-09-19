//
//  UIImageView+Extension.swift
//  tawkGit
//
//  Created by Nazmul Islam on 20/9/21.
//

import UIKit

extension UIImageView {
    func setImage(with url: URL, placeholder: UIImage?) {
        image = placeholder

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let imageLoader = appDelegate.factory?.imageLoader
        else {
            return
        }

        imageLoader.getImage(url: url) {
            [weak self] image in

            guard let self = self,
                  let image = image
            else {
                return
            }
            
            self.image = image
        }
    }

    func setImage(with urlStr: String, placeholder: UIImage?) {
        image = placeholder

        guard let url = URL(string: urlStr) else {
            return
        }

        setImage(with: url, placeholder: placeholder)
    }
}
