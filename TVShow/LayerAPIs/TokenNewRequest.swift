//
//  TokenNewRequest.swift
//  TVShow
//
//  Created by Osvaldo Salas on 19/03/22.
//

import Foundation

struct TokenNewRequest: Codable {
    let redirectTo: String

    enum CodingKeys: String, CodingKey {
        case redirectTo
    }
}
