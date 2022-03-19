//
//  Encodable+toDictionary.swift
//  TVShow
//
//  Created by Osvaldo Salas on 17/03/22.
//

import Foundation

extension Encodable {
    func dictionary(withNulls: Bool = true) -> [String: Any]? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .millisecondsSince1970
        guard let json = try? encoder.encode(self),
            let dict = try? JSONSerialization.jsonObject(with: json, options: []) as? [String: Any] else {
                return nil
        }
        return withNulls ? dict : dict.compactMapValues { $0 }
    }
}
