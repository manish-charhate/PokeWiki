//
//  ViewController.swift
//  PokeWiki
//
//  Created by Manish Charhate on 16/06/21.
//

import UIKit

final class ViewController: UIViewController {

    private let collectionView: UICollectionView
    private let searchBar: UISearchBar
    private var pokemons = [Pokemon]()
    var viewModel: HomeViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            setupViewModel(viewModel)
        }
    }

    private static let cellHeight = 150

    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 20
        flowLayout.sectionHeadersPinToVisibleBounds = true
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(PokemonCardCell.self, forCellWithReuseIdentifier: "PokemonCardCell")

        searchBar = UISearchBar(frame: .zero)
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search by name, type or abilities.."
        searchBar.showsCancelButton = true
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "PokeWiki"
        navigationController?.navigationBar.prefersLargeTitles = true

        view.addSubview(collectionView)
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupViewModel(_ viewModel: HomeViewModel) {
        viewModel.dataFetchCompletionHandler = { [weak self] (pokemons, error) in
            guard let pokemons = pokemons else {
                return
            }

            self?.pokemons.append(contentsOf: pokemons)
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        viewModel.loadInitialData()
    }

}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemons.count
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == pokemons.count - 10 {
            viewModel?.loadMore()
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonCardCell", for: indexPath) as! PokemonCardCell
        let pokemon = pokemons[indexPath.row]
        cell.configure(with: pokemon.name, id: pokemon.id, imageURLString: pokemon.imageURLString)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insets = collectionView.contentInset.left + collectionView.contentInset.right
        let margins = view.layoutMargins.left + view.layoutMargins.right
        let availableWidth = collectionView.frame.width - insets - margins
        return CGSize(width: availableWidth, height: PokemonCardCell.height)
    }

}

extension ViewController: UISearchBarDelegate {

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // no-op
    }
}

