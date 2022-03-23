//
//  LoginAPI.swift
//  TVShow
//
//  Created by Osvaldo Salas on 19/03/22.
//

import Foundation

struct LoginAPI: Requestable {
    typealias ResponseType = TokenNewResponse
    var baseURL: String = APIClient.host(APIManager.shared.enviroment).value
    var path: String = ""
    var endpoint: String
    var method: MethodNetwork = .post
    var headers: [String : String]?
    var queryParameters: SerializerType?
    var requestParameters: SerializerType?
    
    init(username: String, password: String, requestToken: String) {
        headers = Headers.headers
        endpoint = "/authentication/token/validate_with_login"
        
        let data = LoginRequest(username: username, password: password, request_token: requestToken)
        requestParameters = .codable(data)
    }
}
