//
//  UILabel+font.swift
//  Movies
//
//  Created by Alexandra on 25.12.2023.
//

import UIKit

extension UILabel {

    convenience init(withSystemFontOfSize fontSize: CGFloat) {
        self.init()
        font = UIFont.systemFont(ofSize: fontSize)
    }

    convenience init(withBoldFontOfSize fontSize: CGFloat) {
        self.init()
        font = UIFont.boldSystemFont(ofSize: fontSize)
    }
}
