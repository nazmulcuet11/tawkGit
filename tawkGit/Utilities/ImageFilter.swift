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
              let inputCGImage = image.cgImage
        else {
            return image
        }

        let inputCIImage = CIImage(cgImage: inputCGImage)
        filter.setDefaults()
        filter.setValue(inputCIImage, forKey: kCIInputImageKey)
        guard let outputCIImage = filter.outputImage else {
            return image
        }

        let context = CIContext(options: nil)
        guard let outputCGImage = context.createCGImage(outputCIImage, from: inputCIImage.extent) else {
            return image
        }
        return UIImage(cgImage: outputCGImage)
    }
}
