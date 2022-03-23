//
//  TokenNew.swift
//  TVShow
//
//  Created by Osvaldo Salas on 18/03/22.
//

import Foundation

struct TokenNewAPI: Requestable {
    typealias ResponseType = TokenNewResponse
    var baseURL: String = APIClient.host(APIManager.shared.enviroment).value
    var path: String = APIClient.authentication.value
    var endpoint: String
    var method: MethodNetwork = .get
    var headers: [String : String]?
    var queryParameters: SerializerType?
    var requestParameters: SerializerType?
    
    init() {
        headers = Headers.headers
        endpoint = "/new"
    }
}
