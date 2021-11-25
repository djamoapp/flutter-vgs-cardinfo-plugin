//
//  Image.swift
//  vgscardinfo
//
//  Created by Nehemie Koffi on 24/11/2021.
//

import Foundation

@available(iOS 10, *)
extension UIImage {

    func resize(targetSize: CGSize) -> UIImage {
            return UIGraphicsImageRenderer(size:targetSize).image { _ in
                self.draw(in: CGRect(origin: .zero, size: targetSize))
            }
    }

}
