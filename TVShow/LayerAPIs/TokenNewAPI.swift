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
    var method: MethodNetwork = .post
    var headers: [String : String]?
    var queryParameters: SerializerType?
    var requestParameters: SerializerType?
    
    init()
    {
        let token = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhZTc0Y2Y3Y2IwNDdkOGE4MWRiYjcxYWNkMmYxZTVmYSIsInN1YiI6IjYwNWE4MjA4NDdjOWZiMDA2YWJmMzYzNyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.1cO8-Gn_S7fPoaNO-7LbnJpe-gXbTRlL5OKzxPsH4cY"
        headers = ["Content-Type":"application/json;charset=utf-8", "authorization": "Bearer \(token)",]
        
        endpoint = "/request_token"
//        self.queryParameters = .dictionary([
//            "api_key": "ae74cf7cb047d8a81dbb71acd2f1e5fa"
//        ])
        let data = TokenNewRequest(redirectTo: "http://www.themoviedb.org/")
        requestParameters = .codable(data)
    }
}
