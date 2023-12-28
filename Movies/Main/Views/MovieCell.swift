//
//  MovieCell.swift
//  Movies
//
//  Created by Alexandra on 25.12.2023.
//

import UIKit
import RxSwift

class MovieCell: UITableViewCell {

    private static let primaryFontSize: CGFloat = 18
    private static let secondaryFontSize: CGFloat = 16
    private static let tertiaryFontSize: CGFloat = 12
    private static let verticalInset: CGFloat = 25
    private static let horizontalInset: CGFloat = 25
    private static let posterWidthToCellWidth: CGFloat = 0.3
    private static let posterHeightToCellWidth: CGFloat = 0.45

    private let title: UILabel = {
        @UseAutoLayout var label = UILabel(withBoldFontOfSize: primaryFontSize)
        label.numberOfLines = 3
        return label
    }()

    private let info: UILabel = {
        @UseAutoLayout var label = UILabel(withSystemFontOfSize: secondaryFontSize)
        label.numberOfLines = 3
        label.textColor = .secondaryLabel
        return label
    }()

    private let watchlist: UILabel = {
        @UseAutoLayout var label = UILabel(withBoldFontOfSize: tertiaryFontSize)
        label.textColor = .darkGray
        label.text = "ON MY WATCHLIST"
        label.isHidden = true
        return label
    }()

    private lazy var textStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [title, info, watchlist])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .leading
        stack.spacing = 7
        stack.setCustomSpacing(30, after: info)
        stack.useAutoLayout()
        return stack
    }()

    private let poster: PosterView = {
        @UseAutoLayout var view = PosterView()
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        [textStack, poster].forEach(contentView.addSubview(_:))
        backgroundColor = .clear
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        poster.image = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.activate([
            poster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: MovieCell.horizontalInset),
            poster.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: MovieCell.posterWidthToCellWidth),
            poster.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: MovieCell.posterHeightToCellWidth),
            poster.topAnchor.constraint(equalTo: contentView.topAnchor, constant: MovieCell.verticalInset),
            textStack.leadingAnchor.constraint(equalTo: poster.trailingAnchor, constant: MovieCell.horizontalInset),
            textStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -MovieCell.horizontalInset),
            textStack.centerYAnchor.constraint(equalTo: poster.centerYAnchor)
        ])
    }

    func updateInfo(movie: MovieUIModel) {
        title.text = movie.titleWithReleaseYear
        info.text = movie.durationWithGenre
        poster.image = movie.image
        watchlist.isHidden = !movie.showOnMyWatchList
    }

    static func getCellHeight(for width: CGFloat) -> CGFloat {
        width * posterHeightToCellWidth + verticalInset * 2
    }

}
