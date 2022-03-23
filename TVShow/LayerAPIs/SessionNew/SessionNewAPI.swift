//
//  SessionNewAPI.swift
//  TVShow
//
//  Created by Osvaldo Salas on 19/03/22.
//

import Foundation

struct SessionNewAPI: Requestable {
    typealias ResponseType = SessionNewResponse
    var baseURL: String = APIClient.host(APIManager.shared.enviroment).value
    var path: String = APIClient.session.value
    var endpoint: String
    var method: MethodNetwork = .post
    var headers: [String : String]?
    var queryParameters: SerializerType?
    var requestParameters: SerializerType?
    
    init(request_token: String) {
        headers = Headers.headers
        endpoint = "/new"
        let data = SessionNewRequest(request_token: request_token)
        requestParameters = .codable(data)
    }
}
