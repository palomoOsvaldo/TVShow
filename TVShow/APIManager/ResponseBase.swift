//
//  ResponseBase.swift
//  TVShow
//
//  Created by Osvaldo Salas on 18/03/22.
//

import Foundation

public struct ResponseBase: Codable {
    
    //Properties for error
    public let status_code: Int?
    public let status_message: String?
}
