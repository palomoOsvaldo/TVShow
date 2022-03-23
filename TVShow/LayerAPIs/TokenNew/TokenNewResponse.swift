//
//  TokenNewResponse.swift
//  TVShow
//
//  Created by Osvaldo Salas on 18/03/22.
//

import Foundation

struct TokenNewResponse: Codable {
    let success: Bool
    let expires_at: String
    let request_token: String
}
