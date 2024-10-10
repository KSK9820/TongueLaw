//
//  TabbarController.swift
//  TongueLaw
//
//  Created by 최승범 on 10/10/24.
//

import UIKit

final class UserTabBarController: UITabBarController {
    
    private var tabs = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBar()
        configureTabBarItem()
    }
    
    private func configureTabBar() {
        tabBar.unselectedItemTintColor = .lightGray
    }
    
    private func tabBarComponent(vc: UIViewController, type: TabBarType) {
        let viewController = vc
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(title: type.title,
                                                       image: UIImage(systemName: type.icon),
                                                       tag: type.rawValue)
        tabs.append(navigationController)
    }
    
    private func configureTabBarItem() {
        
        tabBarComponent(vc: HomeViewController(), type: .home)
        tabBarComponent(vc: SearchViewController(), type: .topSearch)
        tabBarComponent(vc: FavoriteListViewController(), type: .favorite)
        
        setViewControllers(tabs, animated: false)
    }
    
}

private enum TabBarType: Int, CaseIterable {
    
    case home
    case topSearch
    case favorite
    
    var title: String {
        switch self {
        case .home:
            "Home"
        case .topSearch:
            "Top Search"
        case .favorite:
            "Favorite"
        }
    }
    
    var icon: String {
        switch self {
        case .home:
            "house"
        case .topSearch:
            "magnifyingglass"
        case .favorite:
            "face.smiling"
        }
    }
}
