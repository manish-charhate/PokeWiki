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

    private static let cornerRadius: CGFloat = 12.0
    private static let imageWidth: CGFloat = 150.0

    override var reuseIdentifier: String {
        return "PokemonCardCell"
    }

    // MARK:- Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
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

    func configure(with name: String?, id: Int?, imageURLString: String?) {
        nameLabel.text = name

        if let id = id {
            numberLabel.text = String(id)
        }

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
        contentView.backgroundColor = .white
        contentView.addSubview(imageView)
        contentView.addSubview(numberLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(activityIndicator)

        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.layer.borderWidth = 0.5
        contentView.layer.cornerRadius = PokemonCardCell.cornerRadius
    }

    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

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
        ])
    }
}
