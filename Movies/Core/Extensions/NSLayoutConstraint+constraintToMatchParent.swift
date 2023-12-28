//
//  NSLayoutConstraint+constraintToMatchParent.swift
//  Movies
//
//  Created by Alexandra on 25.12.2023.
//

import UIKit

extension NSLayoutConstraint {

    static func constraintFrameToMatchParent(
        child: UIView?,
        parent: UIView?,
        leadingConstraint: CGFloat = 0,
        trailingConstraint: CGFloat = 0,
        topConstraint: CGFloat = 0,
        bottomConstraint: CGFloat = 0
    ) {
        guard let child = child, let parent = parent else {
            return
        }
        NSLayoutConstraint.activate([
            child.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: leadingConstraint),
            child.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: trailingConstraint),
            child.topAnchor.constraint(equalTo: parent.topAnchor, constant: topConstraint),
            child.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: bottomConstraint),
        ])
    }
}
