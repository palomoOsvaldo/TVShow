//
//  ResponseBase.swift
//  TVShow
//
//  Created by Osvaldo Salas on 18/03/22.
//

import Foundation

public struct ResponseBase<T>: Codable where T: Codable {
    
    public let tokenNew: T?
    
    public let page: Int?
    public let results: T?
    public let total_pages: Int?
    public let total_results: Int?
    
    //Properties for error
    public let status_code: Int?
    public let status_message: String?
}
