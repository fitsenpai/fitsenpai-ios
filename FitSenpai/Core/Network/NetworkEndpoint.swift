//
//  NetworkEndpoint.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/25/25.
//

import Foundation
import CoreKit

protocol ParameterProtocol: Encodable { }

extension NetworkEndpoint {
    
    var baseURL: URL? {
        URL(string: EnvironmentManager.shared.value(for: .baseURL) ?? "")
    }
    
    var headers: [String: String]? { nil }
    
    var queryItems: [URLQueryItem]? { nil }
    
    var body: [String: Any]? { nil }
    
    var timeoutInterval: TimeInterval { 180.0 }
    
    var cachePolicy: URLRequest.CachePolicy { .reloadIgnoringLocalAndRemoteCacheData }
    
    var retryLimit: Int { 3 }
    
    var isLoggingEnabled: Bool { false }
}
