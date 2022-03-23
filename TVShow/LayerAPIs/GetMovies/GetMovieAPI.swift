//
//  GetMovieAPI.swift
//  TVShow
//
//  Created by Osvaldo Salas on 22/03/22.
//

import Foundation

struct GetMovieAPI: Requestable {
    typealias ResponseType = GetMovieResponse
    var baseURL: String = APIClient.host(APIManager.shared.enviroment).value
    var path: String = APIClient.tv.value
    var endpoint: String
    var method: MethodNetwork = .get
    var headers: [String : String]?
    var queryParameters: SerializerType?
    
    init(selectedOption: MenuSGV) {
        headers = Headers.headers
        endpoint = "/authentication/token/validate_with_login"
        
        switch selectedOption {
        case .popular:
            endpoint = "/popular"
        case .topRated:
            endpoint = "/top_rated"
        case .onTV:
            endpoint = "/on_the_air"
        case .airingToday:
            endpoint = "/airing_today"
        }
        
        let locale = Locale.current
        self.queryParameters = .dictionary([
            "language": locale.identifier ?? "es-MX",
            "page": 1,
            "region": locale.regionCode ?? "MX"
        ])
    }
}
