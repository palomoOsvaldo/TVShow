//
//  LoginResponse.swift
//  TVShow
//
//  Created by Osvaldo Salas on 19/03/22.
//

import Foundation

struct LoginResponse: Codable {
    let success: Bool?
    let expiresAt, requestToken: String?
    let status_message : String?
    let status_code: Int?
}
