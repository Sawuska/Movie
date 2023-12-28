//
//  PosterView.swift
//  Movies
//
//  Created by Alexandra on 25.12.2023.
//

import UIKit

class PosterView: UIView {

    private let poster: UIImageView = {
        @UseAutoLayout var view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()

    var image: UIImage? {
        get {
            poster.image
        }
        set {
            poster.image = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(poster)
        backgroundColor = .clear
        clipsToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 5
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.constraintFrameToMatchParent(child: poster, parent: self)
    }

}
