//
//  Serializer.swift
//  TVShow
//
//  Created by Osvaldo Salas on 17/03/22.
//

import Foundation

public protocol Serializer {
    init()
    func serialize() -> Data?
    func serializeForQueryParameters() -> String
}

public class CodableSerializer<T: Encodable>: Serializer {
    public required init() {}
    
    public init(data: T) {
        self.data = data
    }
    
    private var data: T? = nil

    public func serialize() -> Data? {
        let encoder = JSONEncoder()
        guard let dataFromCodable = self.data,
              let encoded = try? encoder.encode(dataFromCodable)
              else { return nil }
        return encoded
    }
    
    public func serializeForQueryParameters() -> String {
        guard let dictionary = data?.dictionary(withNulls: false) else {
            return ""
        }
        return DictModel.encodeDictionary(dictionary)
    }

    
}

public class TextSerializer: Serializer {
    public required init() {}
    
    public init(data: String){
        self.data = data
    }
    
    private var data: String? = nil
    
    public func serialize() -> Data? {
        guard let text = self.data, let textData = text.data(using: .utf8) else {
            return nil
        }
        return textData
    }
    
    
    public func serializeForQueryParameters() -> String {
        return self.data ?? ""
    }

}

public class DictionarySerializer: Serializer {
    public required init() {}
    
    public init(data: Dictionary<String, Any>){
        self.data = data
    }
    
    private var data: Dictionary<String, Any>? = nil
    
    public func serialize() -> Data? {
        guard let dictionaryData = self.data, let jsonData = try? JSONSerialization.data(withJSONObject: dictionaryData, options: []) else {
            return nil
        }
        return jsonData
    }
    
    public func serializeForQueryParameters() -> String {
        guard let dictionary = data else {
            return ""
        }
        return DictModel.encodeDictionary(dictionary)
    }

}


struct AnyEncodable: Encodable {
    let value: Encodable
    
    func encode(to encoder: Encoder) throws {
        try self.value.encode(to: encoder)
    }
}

public enum SerializerType {
    case codable(_ data: Codable)
    case dictionary(_ data: Dictionary<String, Any>)
    case text(_ data: String)
    
    var serializer: Serializer? {
        switch self {
        case .codable(let serializer):
            let anyCodable = AnyEncodable(value: serializer)
            return CodableSerializer(data: anyCodable)
        case .dictionary(let dictionary):
            return DictionarySerializer(data: dictionary)
        case .text(let text):
            return TextSerializer(data: text)
        }
    }
    
}
