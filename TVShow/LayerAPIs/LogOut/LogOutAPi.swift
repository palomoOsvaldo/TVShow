//
//  LogOutAPi.swift
//  TVShow
//
//  Created by Osvaldo Salas on 22/03/22.
//

import Foundation

struct LogOutAPI: Requestable {
    typealias ResponseType = LogOutResponse
    var baseURL: String = APIClient.host(APIManager.shared.enviroment).value
    var path: String = APIClient.authentication.value
    var endpoint: String
    var method: MethodNetwork = .delete
    var headers: [String : String]?
    var requestParameters: SerializerType?
    
    init() {
        endpoint = ""
        headers = Headers.headers
        let session = UserDefaults.standard.string(forKey: Constants.sessionID)
        let data = LogOutRequest(session_id: session ?? "")
        requestParameters = .codable(data)
    }
}
