//
//  NetworkEndpoint.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/3/25.
//

import Foundation

/// Protocol defining the requirements for an API endpoint
protocol NetworkEndpoint {
    /// The base URL of the endpoint
    var baseURL: String { get }
    
    /// The path component of the endpoint
    var path: String { get }
    
    /// The HTTP method to be used
    var method: HTTPMethod { get }
    
    /// Optional HTTP headers
    var headers: [String: String]? { get }
    
    /// Optional request body
    var body: [String: Any]? { get }
    
    /// Optional query parameters
    var queryItems: [URLQueryItem]? { get }
    
    /// Cache policy for this specific endpoint
    var cachePolicy: URLRequest.CachePolicy? { get }
    
    /// URL of the endpoint
    var url: URL? { get }
}

extension NetworkEndpoint {
    
    var baseURL: String {
        EnvironmentManager.shared.value(for: .apiBaseURL) ?? ""
    }
    
    var url: URL? {
        URL(string: baseURL + path)
    }
    
    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }
    
    var body: [String: Any]? {
        nil
    }
    
    var queryItems: [URLQueryItem]? {
        nil
    }
    
    var cachePolicy: URLRequest.CachePolicy? {
        nil
    }
}
