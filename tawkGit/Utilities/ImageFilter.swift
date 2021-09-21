//
//  ImageFilter.swift
//  tawkGit
//
//  Created by Nazmul Islam on 21/9/21.
//

import UIKit

class ImageFilter {
    private static let invertFilter = CIFilter(name: "CIColorInvert")

    static func invertedImage(_ image: UIImage) -> UIImage {
        guard let filter = ImageFilter.invertFilter,
              let cgImage = image.cgImage
        else {
            return image
        }

        let inputImage = CoreImage.CIImage(cgImage: cgImage)
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        guard let outputImage = filter.outputImage else {
            return image
        }

        return UIImage(ciImage: outputImage)
    }
}
