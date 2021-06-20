//
//  PokemonDetailsCell.swift
//  PokeWiki
//
//  Created by Manish Charhate on 20/06/21.
//

import UIKit

class PokemonDetailsCell: UICollectionViewCell {

    // MARK:- Properties

    let numberLabel = UILabel()
    let titleLabel = UILabel()
    let imageView = UIImageView()
    let topStackView = UIStackView()
    let infoStackView = UIStackView()
    let loadingIndicator = UIActivityIndicatorView()
    let heightWeightStackView = UIStackView()
    let heightLabel = UILabel()
    let weightLabel = UILabel()
    let abilitiesTextLabel = UILabel()
    let typesTextLabel = UILabel()

    private static let imageSize = CGSize(width: 300.0, height: 300.0)
    private static let headingLabelFont = UIFont(name: "HelveticaNeue-Bold", size: 40)

    override var reuseIdentifier: String {
        return "PokemonDetailsCell"
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
        imageView.image = nil
        titleLabel.text = nil
        numberLabel.text = nil
    }

    func configure(with name: String?,
                   id: String?,
                   imageURLString: String?,
                   abilitiesText: String,
                   typesText: String,
                   heightText: String,
                   weightText: String,
                   statsData: [String : Int]) {
        titleLabel.text = name
        numberLabel.text = id
        heightLabel.text = heightText
        weightLabel.text = weightText
        abilitiesTextLabel.text = abilitiesText
        typesTextLabel.text = typesText

        if let urlString = imageURLString,
           let url = URL(string: urlString) {
            ImageService.image(for: url) { image in
                DispatchQueue.main.async { [weak self] in
                    self?.imageView.image = image
                    self?.loadingIndicator.stopAnimating()
                }
            }
        }

        showStats(with: statsData)
    }

    // MARK:- Private Helpers

    private func setupSubviews() {
        topStackView.axis = .horizontal
        topStackView.spacing = 16.0
        topStackView.addArrangedSubview(numberLabel)
        topStackView.addArrangedSubview(titleLabel)
        contentView.addSubview(topStackView)
        contentView.addSubview(imageView)
        contentView.addSubview(infoStackView)
        contentView.addSubview(loadingIndicator)
        setupInfoStackView()
    }

    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30.0),
            topStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 30.0),
            imageView.widthAnchor.constraint(equalToConstant: PokemonDetailsCell.imageSize.width),
            imageView.heightAnchor.constraint(equalToConstant: PokemonDetailsCell.imageSize.height),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            infoStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16.0),
            infoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }

    private func stylizeViews() {
        numberLabel.font = PokemonDetailsCell.headingLabelFont
        numberLabel.textColor = .white

        titleLabel.font = PokemonDetailsCell.headingLabelFont
        titleLabel.textColor = .white

        imageView.contentMode = .scaleAspectFit

        loadingIndicator.style = .large
        loadingIndicator.color = .white
        loadingIndicator.startAnimating()

        heightLabel.font = UIFont(name: "HelveticaNeue", size: 20)
        heightLabel.textColor = .cyan

        weightLabel.font = UIFont(name: "HelveticaNeue", size: 20)
        weightLabel.textColor = .cyan

        abilitiesTextLabel.font = UIFont(name: "HelveticaNeue", size: 20)
        abilitiesTextLabel.textColor = .yellow

        typesTextLabel.font = UIFont(name: "HelveticaNeue", size: 20)
        typesTextLabel.textColor = .yellow
    }

    private func setupInfoStackView() {
        infoStackView.axis = .vertical
        infoStackView.spacing = 40
        infoStackView.distribution = .fillProportionally
        setupHeightWeightStackView()
        infoStackView.addArrangedSubview(heightWeightStackView)

        infoStackView.addArrangedSubview(textualInfoView(with: "Abilities:", secondaryLabel: abilitiesTextLabel))
        infoStackView.addArrangedSubview(textualInfoView(with: "Types:", secondaryLabel: typesTextLabel))
    }

    private func setupHeightWeightStackView() {
        let weightInfoView = primarySecondaryContainerView(primaryLabelText: "Weight", secondaryLabel: weightLabel)
        let heightInfoView = primarySecondaryContainerView(primaryLabelText: "Height", secondaryLabel: heightLabel)

        heightWeightStackView.axis = .horizontal
        heightWeightStackView.distribution = .fillEqually
        heightWeightStackView.alignment = .fill
        heightWeightStackView.addArrangedSubview(weightInfoView)
        heightWeightStackView.addArrangedSubview(heightInfoView)
    }

    private func primarySecondaryContainerView(primaryLabelText: String,
                                               secondaryLabel: UILabel) -> UIStackView {
        let containerStackView = UIStackView()
        let primaryLabel = titleLabel(with: primaryLabelText)

        containerStackView.addArrangedSubview(primaryLabel)
        containerStackView.addArrangedSubview(secondaryLabel)
        containerStackView.axis = .vertical
        containerStackView.spacing = 12
        containerStackView.alignment = .center
        return containerStackView
    }

    private func textualInfoView(with text: String, secondaryLabel: UILabel) -> UIView {
        let primaryLabel = titleLabel(with: text)
        let stackView = UIStackView()
        stackView.addArrangedSubview(primaryLabel)
        stackView.addArrangedSubview(secondaryLabel)
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 12
        return stackView
    }

    private func titleLabel(with text: String) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.text = text
        titleLabel.font = UIFont(name: "HelveticaNeue", size: 20)
        titleLabel.textColor = .white
        return titleLabel
    }

    private func showStats(with stats: [String : Int]) {
        let statsStackView = UIStackView()
        statsStackView.axis = .vertical
        statsStackView.spacing = 10
        statsStackView.addArrangedSubview(titleLabel(with: "Stats:"))

        for stat in stats {
            let containerView = UIView()
            let label = UILabel()
            label.textColor = .white
            label.text = stat.key
            containerView.addSubview(label)

            let progressView = UIProgressView()
            progressView.progress = Float(stat.value) / 100.0
            containerView.addSubview(progressView)

            statsStackView.addArrangedSubview(containerView)
            containerView.translatesAutoresizingMaskIntoConstraints = false
            label.translatesAutoresizingMaskIntoConstraints = false
            progressView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                containerView.heightAnchor.constraint(equalToConstant: 30.0),
                label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                progressView.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 16.0),
                progressView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                progressView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            ])
        }

        infoStackView.addArrangedSubview(statsStackView)
    }

}

