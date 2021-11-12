//
//  Colors.swift
//  Runner
//
//  Created by Nehemie Koffi on 09/11/2021.
//

import Foundation

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

class AppColors {
    static let greyColor  = UIColor(r: 153, g: 153, b: 153)
    static let blueColor  = UIColor(r: 12, g: 41, b: 255)
}
