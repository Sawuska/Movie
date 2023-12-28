//
//  MovieInfoView.swift
//  Movies
//
//  Created by Alexandra on 27.12.2023.
//

import UIKit

final class MovieInfoView: UIView {
    private static let fontSize: CGFloat = 14
    private static let verticalInset: CGFloat = 15
    private static let horizontalInset: CGFloat = 20
    private static let posterSideToParentWidth: CGFloat = 0.4

    private static func fieldLabel(name: String) -> UILabel {
        @UseAutoLayout var view = UILabel(withBoldFontOfSize: fontSize)
        view.text = name
        return view
    }

    private static func fieldValue() -> UILabel {
        @UseAutoLayout var view = UILabel(withSystemFontOfSize: fontSize)
        view.textColor = .secondaryLabel
        return view
    }

    private let genreLabel: UILabel = fieldLabel(name: "Genre")

    private let releaseDateLabel: UILabel = fieldLabel(name: "Release Date")

    private lazy var labelsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [genreLabel, releaseDateLabel])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .trailing
        stack.spacing = 7
        stack.useAutoLayout()
        return stack
    }()

    private let genreValue: UILabel = fieldValue()

    private let releaseDateValue: UILabel = fieldValue()

    private lazy var valuesStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [genreValue, releaseDateValue])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        stack.spacing = 7
        stack.useAutoLayout()
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        [labelsStackView, valuesStackView].forEach(addSubview(_:))
        backgroundColor = .systemBackground
        useAutoLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.activate([
            labelsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            labelsStackView.topAnchor.constraint(equalTo: self.topAnchor),

            valuesStackView.leadingAnchor.constraint(equalTo: labelsStackView.trailingAnchor, constant: 15),
            valuesStackView.topAnchor.constraint(equalTo: self.topAnchor),
        ])
    }

    func update(with uiModel: MovieDetailsUIModel) {
        releaseDateValue.text = uiModel.releasedDate
        genreValue.text = uiModel.genre
    }
}

