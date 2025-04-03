//
//  NetworkServiceProtocol.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/2/25.
//


import Foundation
import os.log

protocol NetworkServiceProtocol {
    func request<T: Decodable>(endpoint: NetworkEndpoint) async throws -> T
}

final class NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    private let configuration: NetworkConfiguration
    private let interceptor: RequestInterceptor
    private let validator: ResponseValidator
    private let logger: Logger
    private let cache: URLCache
    
    init(
        configuration: NetworkConfiguration = .default,
        session: URLSession = .shared,
        interceptor: RequestInterceptor = DefaultRequestInterceptor(),
        validator: ResponseValidator = DefaultResponseValidator(),
        cache: URLCache = .shared
    ) {
        self.configuration = configuration
        self.session = session
        self.interceptor = interceptor
        self.validator = validator
        self.cache = cache
        self.logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "NetworkService",
                             category: String(describing: NetworkService.self))
    }
    
    func request<T: Decodable>(endpoint: NetworkEndpoint) async throws -> T {
        do {
            let request = try buildURLRequest(for: endpoint)
            logRequest(request)
            
            let adaptedRequest = try await adaptRequest(request)
            let (data, response) = try await performRequest(adaptedRequest)
            
            try validator.validate(data, response: response)
            logResponse(response, for: adaptedRequest)
            
            return try decodeResponse(data)
            
        } catch {
            logger.error("❌ Network error: \(error.localizedDescription)")
            throw mapError(error)
        }
    }
    
    // MARK: - Private Request Building Methods
    
    private func buildURLRequest(for endpoint: NetworkEndpoint) throws -> URLRequest {
        var urlComponents = URLComponents(url: configuration.baseURL.appendingPathComponent(endpoint.path),
                                       resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = endpoint.queryItems
        
        guard let url = urlComponents?.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url,
                                 cachePolicy: endpoint.cachePolicy ?? configuration.cachePolicy,
                               timeoutInterval: configuration.timeoutInterval)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        if let body = endpoint.body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }
        
        return request
    }
    
    private func adaptRequest(_ request: URLRequest) async throws -> URLRequest {
        try await interceptor.adapt(request)
    }
    
    // MARK: - Private Request Execution Methods
    
    private func performRequest(_ request: URLRequest) async throws -> (Data, URLResponse) {
        var currentRequest = request
        var lastError: Error?
        
        for attempt in 0...configuration.retryLimit {
            do {
                if attempt > 0 {
                    try await handleRetryAttempt(attempt)
                }
                
                return try await session.data(for: currentRequest)
                
            } catch {
                lastError = error
                if try await shouldRetry(currentRequest, error: error) {
                    currentRequest = try await interceptor.adapt(request)
                    continue
                }
                break
            }
        }
        
        throw lastError ?? NetworkError.networkFailure(NSError(domain: "", code: -1))
    }
    
    private func handleRetryAttempt(_ attempt: Int) async throws {
        logger.debug("Retrying request (attempt \(attempt)/\(self.configuration.retryLimit))")
        try await Task.sleep(nanoseconds: UInt64(configuration.retryDelay * 1_000_000_000))
    }
    
    private func shouldRetry(_ request: URLRequest, error: Error) async throws -> Bool {
        try await interceptor.retry(request, for: nil, error: error)
    }
    
    // MARK: - Private Response Handling Methods
    
    private func decodeResponse<T: Decodable>(_ data: Data) throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            logger.error("❌ Decoding error: \(error.localizedDescription)")
            throw NetworkError.decodingError(error)
        }
    }
    
    // MARK: - Private Logging Methods
    
    private func logRequest(_ request: URLRequest) {
        logger.debug("📤 \(request.httpMethod ?? "GET") \(request.url?.absoluteString ?? "")")
        if let headers = request.allHTTPHeaderFields {
            logger.debug("Headers: \(headers)")
        }
    }
    
    private func logResponse(_ response: URLResponse, for request: URLRequest) {
        if let httpResponse = response as? HTTPURLResponse {
            logger.debug("📥 [\(httpResponse.statusCode)] \(request.url?.absoluteString ?? "")")
        }
    }
    
    // MARK: - Private Error Handling
    
    private func mapError(_ error: Error) -> NetworkError {
        switch error {
        case is DecodingError:
            return .decodingError(error)
        case is EncodingError:
            return .encodingError(error)
        case let networkError as NetworkError:
            return networkError
        case URLError.cancelled:
            return .cancelled
        default:
            return .networkFailure(error)
        }
    }
}

#if DEBUG
final class MockNetworkService: NetworkServiceProtocol {
    var mockResult: Any?
    var mockError: Error?
    
    func request<T: Decodable>(endpoint: NetworkEndpoint) async throws -> T {
        try await request(endpoint: endpoint, cachePolicy: nil)
    }
    
    func request<T: Decodable>(endpoint: NetworkEndpoint, cachePolicy: URLRequest.CachePolicy?) async throws -> T {
        if let error = mockError {
            throw error
        }
        
        if let result = mockResult as? T {
            return result
        }
        
        throw NetworkError.invalidResponse
    }
}
#endif
