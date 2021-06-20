//
//  DetailsViewController.swift
//  PokeWiki
//
//  Created by Manish Charhate on 20/06/21.
//

import UIKit

/**
 Shows details about a `Pokemon`
 */
class DetailsViewController: UIViewController {

    // MARK:- Properties

    private let pokemon: Pokemon
    private let collectionView: UICollectionView

    // MARK:- Initializers

    init(with pokemon: Pokemon) {
        self.pokemon = pokemon
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 20
        flowLayout.sectionHeadersPinToVisibleBounds = true
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(PokemonDetailsCell.self, forCellWithReuseIdentifier: "PokemonDetailsCell")

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK:- Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = AppColors.backgroundColor
        navigationItem.title = pokemon.capitalizedName

        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 40, left: 12, bottom: 0, right: 12)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}

// MARK:- UICollectionView DataSource and Delegate

extension DetailsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonDetailsCell", for: indexPath) as! PokemonDetailsCell
        cell.configure(
            with: pokemon.capitalizedName,
            id: pokemon.idText,
            imageURLString: pokemon.imageURLString,
            abilitiesText: pokemon.abilitiesText,
            typesText: pokemon.typesText,
            heightText: pokemon.heightText,
            weightText: pokemon.weightText,
            statsData: pokemon.statsData)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insets = collectionView.contentInset.left + collectionView.contentInset.right
        let margins = view.layoutMargins.left + view.layoutMargins.right
        let availableWidth = collectionView.frame.width - insets - margins
        return CGSize(width: availableWidth, height: view.frame.height)
    }

}
