//
//  MainTabController.swift
//  MyApp
//
//  Created by SAHIL AMRUT AGASHE on 12/12/23.
//

import UIKit

class MainTabController: UITabBarController {
     
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.backgroundColor = .systemGroupedBackground
        
        let mapNav = navController(rootViewController: MapViewController(), title: "Map", image: UIImage(systemName: "mappin.and.ellipse.circle"), SelectedImage: UIImage(systemName: "mappin.and.ellipse.circle.fill"))

        let myBookingNav = navController(rootViewController: MyBookingViewController(), title: "My Booking", image: UIImage(systemName: "square.and.pencil.circle"), SelectedImage: UIImage(systemName: "square.and.pencil.circle.fill"))
        
        viewControllers = [mapNav, myBookingNav]
    }
    
    // MARK: - Private Helpers
    private func navController(rootViewController: UIViewController, title: String, image: UIImage?, SelectedImage: UIImage?) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        let tabBarItem = UITabBarItem(title: title, image: image, selectedImage: SelectedImage)
        nav.tabBarItem = tabBarItem
        return nav
    }
    
    
}



