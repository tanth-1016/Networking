//
//  EndPoint.swift
//  RX_Networking
//
//  Created by Luong Manh on 15/12/2023.
//


import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
    case fetch = "FETCH"
}

public enum EndPoint {
    case getSampleDatas
    case upload(params: UploadParams)
    
    var path: String {
        switch self {
        case .getSampleDatas:
            return "/search"
        default:
            return "/upload"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getSampleDatas:
            return .get
        default:
            return .post
        }
    }
    
    var parameters: [String: Any] {
        var params: [String: Any] = [:]
        switch self {
        case .getSampleDatas:
            return ["limit": 10]
        case .upload(let param):
            if let json = try? param.params.toJSON() as? [String: Any] {
                params.merge(json, uniquingKeysWith: {_, _ in true })
            }
        }
        return params
    }
}


