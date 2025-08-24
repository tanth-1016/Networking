//
//  APIClient.swift
//  RX_Networking
//
//  Created by Luong Manh on 15/12/2023.
//

import Foundation
import Combine

public class APIClient {
    let bundle: APIBundle
    
    public init(bundle: APIBundle) {
        self.bundle = bundle
    }
}

public extension APIClient {
    /// // Example: Fetch sample data (GET request)
    /// do {
    ///     let client = APIClient(bundle: .api)
    ///     let data: Sample? = try await client.execute(.getSampleDatas)
    ///     debugPrint(data ?? "")
    /// } catch {
    ///     debugPrint(error.localizedDescription)
    /// }
    func execute<T: Codable>(_ endpoint: EndPoint) async throws -> T? {
        let request = try APIRouter(endpoint: endpoint, bundle: bundle).asURLRequest()
        
        debugPrint("Request", request.url ?? "")
        let session = URLSession(configuration: .ephemeral)
        do {
            let (data, response) = try await session.data(for: request)
            let validatedData = try validateData(data, withResponse: response)
            let decodedResponse = try JSONDecoder.decodeData(validatedData, as: T.self)
            return decodedResponse
        } catch {
            throw error
        }
    }
}

private func validateData(_ data: Data, withResponse response: URLResponse) throws -> Data {
    guard let httpResponse = response as? HTTPURLResponse else {
        debugPrint("Failed to cast URLResponse to HTTPSURLResponse")
        let description = "Couldn't cast URLResponse to HTTPSURLResponse."
        let error = APIError.failure(description: description)
        throw error
    }
    
    try validateStatusCode(httpResponse.statusCode, data: data)
    debugPrint("Status code \(httpResponse.statusCode) is valid")
    
    return data
}

private func validateStatusCode(_ statusCode: Int, data: Data) throws {
    guard (200..<300).contains(statusCode) else {
        debugPrint("Invalid status code: \(statusCode)")
        let description = String(data: data, encoding: .utf8) ?? "Please check your request."
        let error = APIError.badStatusCode(code: statusCode, description: description)
        throw error
    }
}

