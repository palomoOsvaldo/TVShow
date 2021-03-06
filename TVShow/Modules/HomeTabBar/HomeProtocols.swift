//
//  HomeProtocols.swift
//  TVShow
//
//  Created Osvaldo Salas on 16/03/22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

//MARK: Wireframe -
protocol HomeWireframeProtocol: class {
    func getViewControllers() -> [UIViewController]
}
//MARK: Presenter -
protocol HomePresenterProtocol: class {
    func setupViewControllers()
}

//MARK: Interactor -
protocol HomeInteractorProtocol: class {
    
    var presenter: HomePresenterProtocol?  { get set }
}

//MARK: View -
protocol HomeViewProtocol: class {
    var presenter: HomePresenterProtocol?  { get set }
    func display(_ viewControllers: [UIViewController])
}
