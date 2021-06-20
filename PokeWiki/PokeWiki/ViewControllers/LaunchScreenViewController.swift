//
//  LaunchScreenViewController.swift
//  PokeWiki
//
//  Created by Manish Charhate on 20/06/21.
//

import UIKit

/**
 It shows launchscreen of the app with app logo.
 */
final class LaunchScreenViewController: UIViewController {

    // MARK:- Properties

    private let logoImageView = UIImageView(frame: .zero)
    private static let logoImageHeight: CGFloat = 350
    private static let logoImageWidth: CGFloat = 350

    // MARK:- Lifecycle

    override func viewDidLoad() {
        view.backgroundColor = AppColors.backgroundColor
        view.addSubview(logoImageView)

        logoImageView.image = #imageLiteral(resourceName: "PokeWiki")
        logoImageView.alpha = 0

        UIView.animate(withDuration: 1.0) {
            self.logoImageView.alpha = 1.0
        }
        logoImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            logoImageView.heightAnchor.constraint(equalToConstant: LaunchScreenViewController.logoImageHeight),
            logoImageView.widthAnchor.constraint(equalToConstant: LaunchScreenViewController.logoImageWidth),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Delay presentation of home view controller by 2 seconds to have a smooth transition
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            let navigationController = UINavigationController(rootViewController: HomeViewController())
            navigationController.navigationBar.tintColor = .white
            navigationController.navigationBar.barTintColor = AppColors.backgroundColor.withAlphaComponent(0.5)
            navigationController.modalPresentationStyle = .overFullScreen
            self?.present(navigationController, animated: false)
        }
    }
}
