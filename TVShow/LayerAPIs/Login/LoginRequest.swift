//
//  LoginRequest.swift
//  TVShow
//
//  Created by Osvaldo Salas on 19/03/22.
//

import Foundation

struct LoginRequest: Codable {
    let username, password, request_token: String
}
