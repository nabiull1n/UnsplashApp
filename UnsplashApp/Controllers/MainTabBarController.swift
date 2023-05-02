//
//  MainTabBarController.swift
//  UnsplashApp
//
//  Created by Денис Набиуллин on 27.03.2023.
//

import UIKit.UITabBarController

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        createTabBar()
        setupTabBarColors()
    }
    private func setupTabBarColors() {
        tabBar.tintColor = Resources.Colors.blue
        tabBar.backgroundColor = Resources.Colors.white
    }
    let homeNavController = NavigationController(rootViewController: HomeViewController())
    let secondNavController = NavigationController(rootViewController: LikedViewController())
    private func createTabBar() {
        setViewControllers([
            createVC(viewController: homeNavController, title: "Home", image: UIImage(systemName: "house.fill")),
            createVC(viewController: secondNavController, title: "Liked", image: UIImage(systemName: "heart.fill"))
        ] , animated: false)
    }
    private func createVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }
}
