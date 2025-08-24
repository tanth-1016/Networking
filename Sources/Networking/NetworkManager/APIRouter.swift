//
//  APIRouter.swift
//  RX_Networking
//
//  Created by Luong Manh on 15/12/2023.
//


import Foundation

public struct APIRouter {
    var endpoint: EndPoint
    var bundle: APIBundle
    
    // MARK: - URLRequestConvertible
    public func asURLRequest() throws -> URLRequest {
        let path = bundle.path(for: endpoint)
        let baseURL = bundle.baseURL
        let fullURL = "\(baseURL)/\(path)"
        
        guard let url = URL(string: fullURL) else {
            throw APIError.invalidURL
        }
        
        let method = endpoint.httpMethod
        
        var urlRequest = URLRequest(url: url)
        
        // Http method
        urlRequest.httpMethod = method.rawValue
        
        for header in APIConfig.defaultHeaders {
            urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
        urlRequest.timeoutInterval = APIConfig.timeoutInterval
        
        switch method {
        case .get:

            if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                urlComponents.queryItems = endpoint.parameters.map { (key, value) in
                    URLQueryItem(name: key, value: "\(value)")
                }
                urlRequest.url = urlComponents.url
            }
        case .post, .put, .fetch, .delete:
            if let httpBody = try? JSONSerialization.data(withJSONObject: endpoint.parameters) {
                urlRequest.httpBody = httpBody
            }
        }
        
        return urlRequest
    }
}

extension Dictionary where Key == String, Value == Any {
    func toQueryString() -> String {
        self.map { key, value in
            let keyEncoded = key.addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowedStrict) ?? ""
            let valueEncoded = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowedStrict) ?? ""
            return "\(keyEncoded)=\(valueEncoded)"
        }
        .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowedStrict: CharacterSet = {
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "!*'();:@&=+$,/?%#[] ")
        return allowed
    }()
}
