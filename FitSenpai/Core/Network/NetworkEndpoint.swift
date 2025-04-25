//
//  NetworkEndpoint.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/25/25.
//

import Foundation
import CoreKit

extension NetworkEndpoint {
    
    var baseURL: URL? {
        URL(string: EnvironmentManager.shared.value(for: .baseURL) ?? "")
    }
    
    var headers: [String: String]? { nil }
    
    var queryItems: [URLQueryItem]? { nil }
    
    var body: [String: Any]? { nil }
    
    var timeoutInterval: TimeInterval { 60.0 }
    
    var cachePolicy: URLRequest.CachePolicy { .reloadIgnoringLocalAndRemoteCacheData }
    
    var retryLimit: Int { 3 }
}
