//
//  NetworkConfiguration.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/2/25.
//


import Foundation

/// Configuration for network service
struct NetworkConfiguration {
    let baseURL: URL
    let timeoutInterval: TimeInterval
    let cachePolicy: URLRequest.CachePolicy
    let retryLimit: Int
    let retryDelay: TimeInterval
    
    static let `default` = NetworkConfiguration(
        baseURL: URL(string: "https://api.example.com")!,
        timeoutInterval: 30,
        cachePolicy: .useProtocolCachePolicy,
        retryLimit: 3,
        retryDelay: 1.0
    )
}
