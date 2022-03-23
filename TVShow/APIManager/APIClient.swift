//
//  APIClient.swift
//  TVShow
//
//  Created by Osvaldo Salas on 17/03/22.
//

import Foundation

public enum APIClient {
    case host(APILayerEnviroment)
    case hostImage
    case tv
    case authentication
    case session
    
    
    public var value: String {
        switch self {
        case .host(let enviroment):
            switch enviroment {
            case .development:
                return "https://api.themoviedb.org/4"
            case .qa:
                return "https://api.themoviedb.org/4"
            case .release:
                return "https://api.themoviedb.org/3"
            }
        case .hostImage:
            return "https://image.tmdb.org/t/p/w500/"
        case .tv:
            return "/tv"
        case .authentication:
            return "/authentication/token"
        case .session:
            return "authentication/session"
        }
    }
}


