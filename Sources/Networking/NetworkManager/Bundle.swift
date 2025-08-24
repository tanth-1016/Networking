//
//  Bundle.swift
//  RX_Networking
//
//  Created by Luong Manh on 15/12/2023.
//


import Foundation

public enum APIBundle: Int, Codable {
    case upload
    case api
}

public extension APIBundle {
    
    var baseURL: String {
        switch self {
        case .api:
            return "https://api.thecatapi.com/v1/images"
        case .upload:
            return ""
        }
    }
}

public extension APIBundle {
    func path(for endpoint: EndPoint) -> String {
        switch endpoint {
        case .upload:
            return ""
        case .getSampleDatas:
            return "search"
        default:
            return ""
        }
    }
}
