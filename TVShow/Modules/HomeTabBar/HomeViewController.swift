//
//  HomeViewController.swift
//  TVShow
//
//  Created Osvaldo Salas on 16/03/22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class HomeViewController: UITabBarController, HomeViewProtocol {

    var presenter: HomePresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func display(_ viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        let title = ["TV Shows", "Favorites"]
        let image = ["rectangle.stack.fill", "star.fill"]
        
        var cont = 0
        if let tabBarItems = tabBar.items {
            for item in tabBarItems {
                item.title = title[cont]
                item.image = UIImage(systemName: image[cont])
                cont += 1
            }
        }
    }
}