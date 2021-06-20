//
//  HomeViewController.swift
//  PokeWiki
//
//  Created by Manish Charhate on 16/06/21.
//

import UIKit

final class HomeViewController: UIViewController {

    // MARK:- Properties

    private let collectionView: UICollectionView
    private let searchBar: UISearchBar
    private let viewModel: HomeViewModel
    private var isInSearchMode = false

    private static let cellHeight = 150
    private static let searchBarPlaceholder = "Search by name, type or ability"

    // MARK:- Initializers

    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 20
        flowLayout.sectionHeadersPinToVisibleBounds = true
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(PokemonCardCell.self, forCellWithReuseIdentifier: "PokemonCardCell")

        searchBar = UISearchBar(frame: .zero)
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = HomeViewController.searchBarPlaceholder

        viewModel = HomeViewModel()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK:- Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self

        view.backgroundColor = AppColors.backgroundColor

        let titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
        navigationItem.title = "PokeWiki"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "text.alignleft"),
            style: .plain,
            target: self,
            action: #selector(sortButtonTapped))

        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 40, left: 12, bottom: 0, right: 12)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self

        searchBar.tintColor = .white

        // SearchBar text
        let searchBarTextField = searchBar.value(forKey: "searchField") as? UITextField
        searchBarTextField?.textColor = AppColors.searchBarTextColor
        searchBarTextField?.backgroundColor = .white

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK:- Private Helpers

    @objc private func sortButtonTapped() {
        let alertController = UIAlertController(title: "Sort By", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(
            title: "A-Z",
            style: .default) { [weak self] _ in
            self?.viewModel.sortData(by: .name)
        })

        alertController.addAction(UIAlertAction(
            title: "1-N",
            style: .default) { [weak self] _ in
            self?.viewModel.sortData(by: .id)
        })

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alertController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(alertController, animated: true)
    }

}

// MARK:- UICollectionView Delegate and DataSource

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredPokemons.count
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if ((viewModel.filteredPokemons.count - indexPath.item) == 2) && !isInSearchMode {
            viewModel.loadMore()
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonCardCell", for: indexPath) as! PokemonCardCell
        let pokemon = viewModel.filteredPokemons[indexPath.row]
        cell.configure(
            with: pokemon.capitalizedName,
            id: pokemon.idText,
            imageURLString: pokemon.imageURLString,
            abilitiesText: pokemon.abilitiesText,
            typesText: pokemon.typesText)
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pokemon = viewModel.filteredPokemons[indexPath.item]
        let pokemonDetailsViewController = DetailsViewController(with: pokemon)
        navigationController?.pushViewController(pokemonDetailsViewController, animated: true)
    }

}

// MARK:- ViewModelDelegate

extension HomeViewController: ViewModelDelegate {

    func didLoadData() {
        collectionView.reloadData()
    }

    func failedToLoadData() {
        // no-op
    }
}

// MARK:- UISearchBarDelegate

extension HomeViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isInSearchMode = true
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        isInSearchMode = false
        viewModel.resetData()
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            viewModel.resetData()
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        guard let searchText = searchBar.text,
              searchText.count > 3 else {
            return
        }
        viewModel.searchPokemons(by: searchText.lowercased()) { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }

}

