//
//  TVShowRouter.swift
//  TVShow
//
//  Created Osvaldo Salas on 16/03/22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class TVShowRouter: TVShowWireframeProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule(typeView: TypeView) -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = TVShowViewController()
        let interactor = TVShowInteractor()
        let router = TVShowRouter()
        let presenter = TVShowPresenter(interface: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        view.typeView = typeView
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
//    func goingToDetailShow(selectShow: ShowsDB) {
//        let vc = DetailRouter.createModule(show: selectShow)
//        viewController?.navigationController?.pushViewController(vc, animated: true)
//    }
}

public enum TypeView {
    case ShowTV
    case Favorites
}