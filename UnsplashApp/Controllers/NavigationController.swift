//
//  NavigationController.swift
//  UnsplashApp
//
//  Created by Денис Набиуллин on 29.03.2023.
//

import UIKit.UINavigationController

final class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    private func configure() {
        navigationBar.backgroundColor = .white
        navigationBar.isTranslucent = true
        navigationBar.barStyle = .default
    }
}
