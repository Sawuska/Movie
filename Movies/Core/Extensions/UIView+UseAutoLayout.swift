//
//  UIView+UseAutoLayout.swift
//  Movies
//
//  Created by Alexandra on 25.12.2023.
//

import UIKit

@propertyWrapper
public struct UseAutoLayout<T: UIView> {
    public var wrappedValue: T {
        didSet {
            setAutoLayout()
        }
    }
    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        setAutoLayout()
    }
    func setAutoLayout() {
        wrappedValue.useAutoLayout()
    }
}

extension UIView {

    func useAutoLayout() {
        translatesAutoresizingMaskIntoConstraints = false
    }
}
