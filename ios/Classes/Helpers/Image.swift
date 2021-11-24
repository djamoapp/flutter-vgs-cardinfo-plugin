//
//  Image.swift
//  vgscardinfo
//
//  Created by Nehemie Koffi on 24/11/2021.
//

import Foundation

extension UIImage {
    public func resized(to target: CGSize) -> UIImage {
        let ratio = min(
            target.height / size.height, target.width / size.width
        )
        let new = CGSize(
            width: size.width * ratio, height: size.height * ratio
        )
        let renderer = UIGraphicsImageRenderer(size: new)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: new))
        }
    }
}

extension UIImage {

func resize(targetSize: CGSize) -> UIImage {
    return UIGraphicsImageRenderer(size:targetSize).image { _ in
        self.draw(in: CGRect(origin: .zero, size: targetSize))
    }
}

}
