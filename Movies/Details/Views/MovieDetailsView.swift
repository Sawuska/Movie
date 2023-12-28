//
//  MovieDetailsView.swift
//  Movies
//
//  Created by Alexandra on 25.12.2023.
//

import UIKit

class MovieDetailsView: UIView {

    private static let fontSize: CGFloat = 18
    private static let secondaryFontSize: CGFloat = 16
    private static let tertiaryFontSize: CGFloat = 12
    private static let verticalInset: CGFloat = 20
    private static let smallVerticalInset: CGFloat = 8
    private static let horizontalInset: CGFloat = 15
    private static let separatorHorizontalInset = horizontalInset * 2
    private static let posterHorizontalInset: CGFloat = 25
    private static let posterWidthToParentWidth: CGFloat = 0.35
    private static let posterHeightToParentWidth: CGFloat = 0.5
    private static let multiplierToIntrinsicSize: CGFloat = 1.2

    private static let normalTitle: NSAttributedString = {
        NSAttributedString(
            string: " + ADD TO WATCHLIST ",
            attributes: [
                .font : UIFont.boldSystemFont(ofSize: tertiaryFontSize),
                .foregroundColor: UIColor.secondaryLabel,])
    }()
    private static let selectedTitle: NSAttributedString = {
        NSAttributedString(
            string: " REMOVE FROM WATCHLIST ",
            attributes: [
                .font : UIFont.boldSystemFont(ofSize: tertiaryFontSize),
                .foregroundColor: UIColor.secondaryLabel,])
    }()


    private let title: UILabel = {
        @UseAutoLayout var label = UILabel(withBoldFontOfSize: fontSize)
        label.numberOfLines = 4
        return label
    }()

    private let rating: UILabel = {
        @UseAutoLayout var label = UILabel(withBoldFontOfSize: fontSize)
        return label
    }()

    private let shortDescription: UILabel = {
        @UseAutoLayout var label = UILabel(withBoldFontOfSize: fontSize)
        label.text = "Short description"
        return label
    }()

    private let overview: UITextView = {
        @UseAutoLayout var view = UITextView()
        view.isEditable = false
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        return view
    }()

    private let poster: PosterView = {
        @UseAutoLayout var view = PosterView()
        return view
    }()

    private let detailsLabel: UILabel = {
        @UseAutoLayout var view = UILabel(withBoldFontOfSize: fontSize)
        view.text = "Details"
        return view
    }()

    private let firstSeparator: UIView = {
        @UseAutoLayout var view = UIView()
        view.backgroundColor = .opaqueSeparator
        return view
    }()

    private let secondSeparator: UIView = {
        @UseAutoLayout var view = UIView()
        view.backgroundColor = .opaqueSeparator
        return view
    }()

    private let info: MovieInfoView = MovieInfoView()

    let watchlistButton: UIButton = {
        @UseAutoLayout var button = UIButton()
        button.layer.masksToBounds = true
        button.setAttributedTitle(
            normalTitle,
            for: .normal)
        button.setAttributedTitle(
            selectedTitle,
            for: .selected)
        button.backgroundColor = .systemGray5
        return button
    }()

    let watchTrailerButton: UIButton = {
        @UseAutoLayout var button = UIButton()
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 2
        let font = UIFont.boldSystemFont(ofSize: tertiaryFontSize)
        button.setAttributedTitle(
            NSAttributedString(
                string: " WATCH TRAILER ",
                attributes: [
                    .font : font,
                    .foregroundColor: UIColor.label,]),
            for: .normal)
        button.backgroundColor = .clear
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        [poster, title, rating, overview, detailsLabel, info, firstSeparator, secondSeparator, shortDescription, watchlistButton, watchTrailerButton].forEach(addSubview(_:))
        backgroundColor = .systemBackground
        useAutoLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        watchlistButton.layer.cornerRadius = watchlistButton.bounds.height / 2
        watchTrailerButton.layer.cornerRadius = watchTrailerButton.bounds.height / 2

        NSLayoutConstraint.constraintFrameToMatchParent(child: self, parent: self.superview)

        NSLayoutConstraint.activate([
            poster.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: MovieDetailsView.posterWidthToParentWidth),
            poster.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: MovieDetailsView.posterHeightToParentWidth),
            poster.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: -MovieDetailsView.verticalInset),
            poster.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: MovieDetailsView.posterHorizontalInset),

            rating.topAnchor.constraint(equalTo: poster.topAnchor),
            rating.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -MovieDetailsView.horizontalInset),

            title.topAnchor.constraint(equalTo: poster.topAnchor),
            title.trailingAnchor.constraint(equalTo: rating.leadingAnchor, constant: -MovieDetailsView.horizontalInset),
            title.leadingAnchor.constraint(equalTo: poster.trailingAnchor, constant: MovieDetailsView.horizontalInset),

            watchlistButton.topAnchor.constraint(equalTo: title.bottomAnchor, constant: MovieDetailsView.verticalInset),
            watchlistButton.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            watchlistButton.heightAnchor.constraint(equalToConstant: watchlistButton.intrinsicContentSize.height * MovieDetailsView.multiplierToIntrinsicSize),

            watchTrailerButton.topAnchor.constraint(equalTo: watchlistButton.bottomAnchor, constant: MovieDetailsView.verticalInset),
            watchTrailerButton.leadingAnchor.constraint(equalTo: watchlistButton.leadingAnchor),
            watchTrailerButton.widthAnchor.constraint(equalToConstant: watchTrailerButton.intrinsicContentSize.width * MovieDetailsView.multiplierToIntrinsicSize),
            watchTrailerButton.heightAnchor.constraint(equalToConstant: watchTrailerButton.intrinsicContentSize.height * MovieDetailsView.multiplierToIntrinsicSize),

            firstSeparator.topAnchor.constraint(equalTo: poster.bottomAnchor, constant: MovieDetailsView.verticalInset),
            firstSeparator.heightAnchor.constraint(equalToConstant: 1),
            firstSeparator.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            firstSeparator.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, constant: -MovieDetailsView.separatorHorizontalInset),

            shortDescription.topAnchor.constraint(equalTo: firstSeparator.bottomAnchor, constant: MovieDetailsView.verticalInset),
            shortDescription.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: MovieDetailsView.horizontalInset),

            overview.topAnchor.constraint(equalTo: shortDescription.bottomAnchor, constant: MovieDetailsView.smallVerticalInset),
            overview.trailingAnchor.constraint(equalTo: rating.trailingAnchor),
            overview.leadingAnchor.constraint(equalTo: poster.leadingAnchor),

            secondSeparator.topAnchor.constraint(equalTo: overview.bottomAnchor, constant: MovieDetailsView.verticalInset),
            secondSeparator.heightAnchor.constraint(equalToConstant: 1),
            secondSeparator.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            secondSeparator.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, constant: -MovieDetailsView.separatorHorizontalInset),

            detailsLabel.topAnchor.constraint(equalTo: secondSeparator.bottomAnchor, constant: MovieDetailsView.verticalInset),
            detailsLabel.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            detailsLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: MovieDetailsView.horizontalInset),

            info.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: MovieDetailsView.smallVerticalInset),
            info.leadingAnchor.constraint(equalTo: poster.leadingAnchor),
        ])
    }

    func update(with uiModel: MovieDetailsUIModel) {
        title.text = uiModel.title
        rating.attributedText = uiModel.rating
        poster.image = uiModel.image
        setAttributedOverview(text: uiModel.overview)
        info.update(with: uiModel)
        watchlistButton.isSelected = uiModel.showOnMyWatchList
    }

    private func setAttributedOverview(text: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .left
        let font = UIFont.systemFont(ofSize: MovieDetailsView.secondaryFontSize)
        let attributedText = NSAttributedString(
            string: text,
            attributes: [
                .paragraphStyle : paragraphStyle,
                .font : font,
                .foregroundColor: UIColor.secondaryLabel,
            ]
        )
        overview.attributedText = attributedText
    }
}
