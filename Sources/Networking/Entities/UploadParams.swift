//
//  UploadParams.swift
//  RX_Networking
//
//  Created by Luong Manh on 15/12/2023.
//

import Foundation

public struct UploadParams {
    public var params: UploadContent
    public var files: [FileUpload]
    
    public init(params: UploadContent, files: [FileUpload]) {
        self.params = params
        self.files = files
    }
}

public struct UploadContent: Encodable {
    public var fileUrl: String?
    public var bundle: APIBundle = .upload

    public init(fileUrl: String?) {
        self.fileUrl = fileUrl
    }
    
    enum CodingKeys: String, CodingKey {
        case fileUrl = "fileurl"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.fileUrl, forKey: .fileUrl)
    }
}
