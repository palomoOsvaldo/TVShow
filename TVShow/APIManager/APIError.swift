//
//  APIError.swift
//  TVShow
//
//  Created by Osvaldo Salas on 17/03/22.
//

import Foundation

public enum APIError: Error {
    case notNetwork
    case notFound
    case timeOut
    case canceled
    case cipherService
    
    /// Indicates the server responded with an unexpected status code.
    /// - parameter Int: The status code the server respodned with.
    /// - parameter Data?: The raw returned data from the server
    case unexpectedStatusCode(Int, Data?)

    /// Indicates that the server responded using an unknown protocol.
    /// - parameter Data?: The raw returned data from the server
    case badResponse(Data?)

    /// Indicates the server's response could not be deserialized using the given Deserializer.
    /// - parameter Data: The raw returned data from the server
    case malformedResponse(Data?)

    /// Inidcates the server did not respond to the request.
    case noResponse
    
    /// Bad URL
    case badURL
    
    func printData() {
        switch self {
        case .unexpectedStatusCode(_, let data), .badResponse(let data), .malformedResponse(let data):
            if let dataToStr = data {
                print(String(decoding: dataToStr, as: UTF8.self))
            }
        default:
            print("Error diferente")
        }
    }
    
    public func getMessageFromService() -> String {
        switch self {
        case .unexpectedStatusCode(_, let data), .badResponse(let data), .malformedResponse(let data):
            guard let dataFromService = data, let jsonDecoder = try? JSONDecoder().decode(ResponseBase.self, from: dataFromService) else {
                return "Error generico"
            }
            
            return jsonDecoder.status_message ?? "genric Error"
            
            
        default:
            return "without Error"
        }
    }
}
