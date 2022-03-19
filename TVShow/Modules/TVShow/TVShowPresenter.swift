//
//  TVShowPresenter.swift
//  TVShow
//
//  Created Osvaldo Salas on 16/03/22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class TVShowPresenter: TVShowPresenterProtocol {

    weak private var view: TVShowViewProtocol?
    var interactor: TVShowInteractorProtocol?
    private let router: TVShowWireframeProtocol

    init(interface: TVShowViewProtocol, interactor: TVShowInteractorProtocol?, router: TVShowWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

}
