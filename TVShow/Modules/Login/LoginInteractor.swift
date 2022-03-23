//
//  LoginInteractor.swift
//  TVShow
//
//  Created Osvaldo Salas on 16/03/22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class LoginInteractor: LoginInteractorProtocol {

    weak var presenter: LoginPresenterProtocol?
    
    func getRequestToken(username: String, password: String) {
        let req = TokenNewAPI()
        APIManager.shared.request(request: req) { result in
            switch result {
            case .success(let data):
                debugPrint("Todo correcto1 \(data)")
                UserDefaults.standard.set(username, forKey: Constants.user)
                self.getLogin(user: username, pass: password, requestToken: data.request_token)
            case .failure(let error):
                debugPrint(error as Any)
                switch error {
                case .notNetwork:
                    debugPrint("No hubo red")
                    self.presenter?.mostrarAlerta(mensaje: Constants.errorNetwork)
                case .unexpectedStatusCode(let status, _):
                        debugPrint("credenciales")
                case .timeOut:
                    debugPrint("TimeOut")
                    self.presenter?.mostrarAlerta(mensaje: Constants.errorTimeOut)
                default:
                    break
                }
            }
        }
    }
    
    func getSessionNew(requestToken: String) {
        let req = SessionNewAPI(request_token: requestToken)
        APIManager.shared.request(request: req) { result in
            switch result {
            case .success(let data):
                debugPrint("Todo correcto1 \(data)")
                DispatchQueue.main.async {
                    UserDefaults.standard.set(data.session_id, forKey: Constants.sessionID)
                    self.presenter?.setSession(session: data.session_id)
                }
            case .failure(let error):
                debugPrint(error as Any)
                switch error {
                case .notNetwork:
                    debugPrint("No hubo red")
                    self.presenter?.mostrarAlerta(mensaje: Constants.errorNetwork)
                case .unexpectedStatusCode(let status, _):
                        debugPrint("credenciales")
                case .timeOut:
                    debugPrint("TimeOut")
                    self.presenter?.mostrarAlerta(mensaje: Constants.errorTimeOut)
                default:
                    break
                }
            }
        }
    }
    
    func getLogin(user: String, pass: String, requestToken: String) {
        let req = LoginAPI(username: user, password: pass, requestToken: requestToken)
        APIManager.shared.request(request: req) { result in
            switch result {
            case .success(let data):
                debugPrint("Todo correcto1 \(data)")
                self.getSessionNew(requestToken: data.request_token)
            case .failure(let error):
                debugPrint(error as Any)
                switch error {
                case .notNetwork:
                    debugPrint("No hubo red")
                    DispatchQueue.main.async {
                        self.presenter?.mostrarAlerta(mensaje: Constants.errorNetwork)
                    }
                case .unexpectedStatusCode(let status, _):
                        debugPrint("credenciales")
                    let error = error?.getMessageFromService()
                    
                    DispatchQueue.main.async {
                        self.presenter?.mostrarAlerta(mensaje: error ?? "")
                    }
                case .timeOut:
                    debugPrint("TimeOut")
                    DispatchQueue.main.async {
                        self.presenter?.mostrarAlerta(mensaje: Constants.errorTimeOut)
                    }
                default:
                    break
                }
            }
        }
    }
}
