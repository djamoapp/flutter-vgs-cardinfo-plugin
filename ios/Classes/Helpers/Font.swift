//
//  Font.swift
//  Runner
//
//  Created by Nehemie Koffi on 09/11/2021.
//

import Foundation

extension UIFont {

    public enum FuturaPtType: String {
        case medium = "-Medium"
        case light = ""
    }

    static func FuturaPT(_ type: FuturaPtType = .medium, size: CGFloat = UIFont.systemFontSize) -> UIFont {
        return UIFont(name: "Futura\(type.rawValue)", size: size)!
    }

    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }

    var isItalic: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }

}
