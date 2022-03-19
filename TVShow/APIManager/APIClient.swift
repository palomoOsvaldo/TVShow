//
//  APIClient.swift
//  TVShow
//
//  Created by Osvaldo Salas on 17/03/22.
//

import Foundation

public enum APIClient {
    case host(APILayerEnviroment)
    case movie
    case authentication
    case key
    
    
    public var value: String {
        switch self {
        case .host(let enviroment):
            switch enviroment {
            case .development:
                return "https://api.themoviedb.org/4"
            case .qa:
                return "https://api.themoviedb.org/4"
            case .release:
                return "https://api.themoviedb.org/4"
            }
        case .movie:
            return "/movie"
        case .authentication:
            return "/auth"
        case .key:
            return "?apyKey=ae74cf7cb047d8a81dbb71acd2f1e5fa"
        }
    }
}


