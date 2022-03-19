//
//  DictModel.swift
//  TVShow
//
//  Created by Osvaldo Salas on 17/03/22.
//

import Foundation

struct DictModel {
    static func encodeDictionary(_ dictionary: [String: Any]) -> String {
        return dictionary
            .compactMap { (key, value) -> String? in
                if value is [String: Any] {
                    if let dictionary = value as? [String: Any] {
                        return encodeDictionary(dictionary)
                    }
                }
                else {
                    return "\(key)=\(value)"
                }
                
                return nil
            }
            .joined(separator: "&")
    }
}
