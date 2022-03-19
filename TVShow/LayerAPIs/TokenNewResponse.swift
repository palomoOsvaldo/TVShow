//
//  TokenNewResponse.swift
//  TVShow
//
//  Created by Osvaldo Salas on 18/03/22.
//

import Foundation

struct TokenNewResponse: Codable {
    let statusMessage, requestToken: String?
    let success: Bool
    let statusCode: Int?

    enum CodingKeys: String, CodingKey {
        case statusMessage
        case requestToken
        case success
        case statusCode
    }
}
