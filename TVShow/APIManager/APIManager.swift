//
//  APIManager.swift
//  TVShow
//
//  Created by Osvaldo Salas on 17/03/22.
//

import Foundation

public protocol Requestable {
    
    associatedtype ResponseType: Codable
    
    var baseURL: String { get }
    var path: String { get }
    var endpoint: String { get }
    var method: MethodNetwork { get }
    var queryParameters: SerializerType? { get }
    var headers: [String: String]? { get set }
    var expectedStatusCode: [Int] { get }
    var requestParameters: SerializerType? { get }
    var requestParametersToken: [String: String]? { get }
    
    var timeout: TimeInterval? { get }
}


public extension Requestable {
    
    
    var expectedStatusCode: [Int] {
        return [200, 201]
    }
        
    var queryParameters: SerializerType? {
        return nil
    }
    
    var timeout: TimeInterval? {
        return 30.0
    }
    
    var requestParameters: SerializerType? {
        return nil
    }
    
    var requestParametersToken: [String: String]? {
        return nil
    }
    
}

public enum APILayerEnviroment {
    case development
    case qa
    case release
}

public enum APIResult<T> {
    case success(T)
    case failure(APIError?)
}

public enum MethodNetwork: String {
    case get = "GET"
    case post = "POST"
}

class APIManager {
    
    public static let shared = APIManager()
    private static let kJsonType = "application/json;charset=utf-8"
    private static let kContentType = "Content-Type"
    private static let networkError = [URLError.Code.networkConnectionLost, URLError.Code.cannotLoadFromNetwork, URLError.Code.notConnectedToInternet]
    public var enviroment: APILayerEnviroment = .release
    let timeOut: TimeInterval = 30.0
    let cachePolicy: NSURLRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    
    private init() {}
    
    func request<T: Requestable>(request: T, completion: @escaping (APIResult<T.ResponseType>) -> Void) {
        let base = URL(string: request.baseURL)!
        
        let url = base.appendingPathComponent(request.path).appendingPathComponent(request.endpoint)

        var urlRequest: URLRequest? = nil
        let timeOut: TimeInterval = request.timeout ?? 30.0
        let cachePolicy: NSURLRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        if let queryParams = request.queryParameters?.serializer {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            components.query = queryParams.serializeForQueryParameters()
            urlRequest = URLRequest(url: components.url!, cachePolicy: cachePolicy, timeoutInterval: timeOut)
        } else {
            urlRequest = URLRequest(url: url, cachePolicy: cachePolicy,
                                 timeoutInterval: timeOut)
        }
        urlRequest!.allHTTPHeaderFields = request.headers
        
        if let dataRequest = request.requestParameters {
            if urlRequest!.allHTTPHeaderFields?[APIManager.kContentType] == nil {
                urlRequest!.setValue(APIManager.kJsonType, forHTTPHeaderField: APIManager.kContentType)
            }
            
            urlRequest!.httpBody = dataRequest.serializer?.serialize()
        }
        
        urlRequest!.httpMethod = request.method.rawValue

        let urlSession = URLSession.shared.dataTask(with: urlRequest!) { data, response, error in
            if let err = error {
                if let urlError = err as? URLError {
                    if urlError.code == .timedOut {
                        completion(APIResult.failure(.timeOut))
                    } else if APIManager.networkError.contains(urlError.code) {
                        completion(APIResult.failure(.notNetwork))
                    }else {
                        completion(APIResult.failure(.malformedResponse(data)))
                    }
                } else {
                    completion(APIResult.failure(.timeOut))
                }
                return
            }

            guard let urlResponse = response as? HTTPURLResponse else { return completion(APIResult.failure(.malformedResponse(data))) }
            if !(200..<300).contains(urlResponse.statusCode) {
                return completion(APIResult.failure(.unexpectedStatusCode(urlResponse.statusCode, data)))
            }

            guard let data = data else { return }
            do {
                let object = try JSONDecoder().decode(T.ResponseType.self, from: data)
                completion(APIResult.success(object))
            } catch let DecodingError.dataCorrupted(context) {
                print("Contexto: \(context)")
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }
        }

        urlSession.resume()
    }
}
