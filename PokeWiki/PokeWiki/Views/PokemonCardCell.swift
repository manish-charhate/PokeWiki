//
//  PokemonCardCell.swift
//  PokeWiki
//
//  Created by Manish Charhate on 17/06/21.
//

import UIKit

class PokemonCardCell: UICollectionViewCell {

    // MARK:- Properties

    static let height: CGFloat = 150.0

    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let numberLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(frame: .zero)
    private let abilitiesTitleLabel = UILabel()
    private let abilitiesTextLabel = UILabel()
    private let typesTitleLabel = UILabel()
    private let typesTextLabel = UILabel()

    private static let cornerRadius: CGFloat = 12.0
    private static let imageWidth: CGFloat = 150.0
    private static let titleFontSize: CGFloat = 16
    private static let headingLabelFont = UIFont(name: "HelveticaNeue-Bold", size: 20)
    private static let titleLabelFont = UIFont(name: "HelveticaNeue-Bold", size: titleFontSize)

    override var reuseIdentifier: String {
        return "PokemonCardCell"
    }

    // MARK:- Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
        stylizeViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK:- Lifecycle

    override func prepareForReuse() {
        activityIndicator.startAnimating()
        imageView.image = nil
        nameLabel.text = nil
        numberLabel.text = nil
    }

    func configure(with name: String?,
                   id: String?,
                   imageURLString: String?,
                   abilitiesText: String,
                   typesText: String) {
        nameLabel.text = name

        typesTitleLabel.text = "Types:"
        abilitiesTitleLabel.text = "Abilities:"

        abilitiesTextLabel.text = abilitiesText
        typesTextLabel.text = typesText
        numberLabel.text = id

        if let urlString = imageURLString,
           let url = URL(string: urlString) {
            ImageService.image(for: url) { image in
                DispatchQueue.main.async { [weak self] in
                    self?.imageView.image = image
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
    }

    // MARK:- Private Helpers

    private func setupSubviews() {
        contentView.backgroundColor = AppColors.lightBackgroundColor
        contentView.addSubview(imageView)
        contentView.addSubview(numberLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(activityIndicator)
        contentView.addSubview(abilitiesTitleLabel)
        contentView.addSubview(abilitiesTextLabel)
        contentView.addSubview(typesTitleLabel)
        contentView.addSubview(typesTextLabel)

        contentView.layer.cornerRadius = PokemonCardCell.cornerRadius
    }

    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        abilitiesTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        abilitiesTextLabel.translatesAutoresizingMaskIntoConstraints = false
        typesTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        typesTextLabel.translatesAutoresizingMaskIntoConstraints = false

        abilitiesTitleLabel.setContentCompressionResistancePriority(.required + 1, for: .horizontal)
        abilitiesTitleLabel.setContentCompressionResistancePriority(.required + 1, for: .vertical)

        typesTitleLabel.setContentCompressionResistancePriority(.required + 1, for: .horizontal)
        typesTitleLabel.setContentCompressionResistancePriority(.required + 1, for: .vertical)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: PokemonCardCell.height),
            imageView.widthAnchor.constraint(equalToConstant: PokemonCardCell.imageWidth),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),

            numberLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12.0),
            numberLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12.0),

            nameLabel.topAnchor.constraint(equalTo: numberLabel.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor, constant: 12.0),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -12.0),

            abilitiesTitleLabel.leadingAnchor.constraint(equalTo: numberLabel.leadingAnchor),
            abilitiesTitleLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 8.0),
            abilitiesTextLabel.leadingAnchor.constraint(equalTo: abilitiesTitleLabel.trailingAnchor, constant: 8.0),
            abilitiesTextLabel.topAnchor.constraint(equalTo: abilitiesTitleLabel.topAnchor),
            abilitiesTextLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -12.0),

            typesTitleLabel.leadingAnchor.constraint(equalTo: numberLabel.leadingAnchor),
            typesTitleLabel.topAnchor.constraint(equalTo: abilitiesTextLabel.bottomAnchor, constant: 8.0),
            typesTextLabel.leadingAnchor.constraint(equalTo: abilitiesTextLabel.leadingAnchor),
            typesTextLabel.topAnchor.constraint(equalTo: typesTitleLabel.topAnchor),
            typesTextLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -12.0),
        ])
    }

    private func stylizeViews() {
        numberLabel.font = PokemonCardCell.headingLabelFont
        numberLabel.textColor = AppColors.cellHeadingTextColor

        nameLabel.font = PokemonCardCell.headingLabelFont
        nameLabel.textColor = AppColors.cellHeadingTextColor

        abilitiesTitleLabel.font = PokemonCardCell.titleLabelFont
        abilitiesTitleLabel.textColor = AppColors.titleTextColor
        abilitiesTextLabel.numberOfLines = 0
        abilitiesTextLabel.font = UIFont.systemFont(ofSize: PokemonCardCell.titleFontSize)

        typesTitleLabel.font = PokemonCardCell.titleLabelFont
        typesTitleLabel.textColor = AppColors.titleTextColor
        typesTextLabel.numberOfLines = 0
        typesTextLabel.font = UIFont.systemFont(ofSize: PokemonCardCell.titleFontSize)
    }

}
