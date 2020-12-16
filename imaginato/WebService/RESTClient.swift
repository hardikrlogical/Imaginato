//
//  RESTClient.swift
//  imaginato
//
//  Created by rlogical-dev-35 on 15/12/20.
//  Copyright © 2020 rlogical-dev-35. All rights reserved.
//

import Alamofire
import Foundation
import RxSwift

enum RESTClient {
    case login(email: String, password: String)
}

extension RESTClient {
    /// A dictionary containing all the HTTP header fields
    fileprivate var headers: HTTPHeaders? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }
    
    /// The URL of the receiver.
    internal var url: String {
        return host + path
    }
    
    /// The host, conforming to RFC 1808.
    fileprivate var host: String {
        return "http://imaginato.mocklab.io"
    }
    
    /// The path, conforming to RFC 1808
    fileprivate var path: String {
        return "/" + endpoint
    }
    
    /// API Endpoint
    fileprivate var endpoint: String {
        switch self {
        case .login:
            return "login"
        }
    }
    
    /// The HTTP request method.
    fileprivate var method: HTTPMethod {
        return .post
    }
    
    /// The HTTP request parameters.
    fileprivate var parameters: [String: Any]? {
        switch self {
        case let .login(email: email, password: password):
            return ["email": email, "password": password]
        }
    }
    
    /// A type used to define how a set of parameters are applied to a URLRequest.
    ///
    /// Returns a JSONEncoding instance with default writing options.
    fileprivate var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}

extension RESTClient {
    func request<T: Codable>(type: T.Type) -> Observable<T> {
        return Observable.create { (observer) -> Disposable in
            
            AF.request(self.url, method: self.method, parameters: self.parameters, encoding: self.encoding, headers: self.headers)
                .responseData { response in
                    switch response.result {
                    case let .success(data):
                        do {
                            let decoder = JSONDecoder()
                            decoder.dateDecodingStrategy = .customISO8601
                            observer.onNext(try decoder.decode(type, from: data))
                            observer.onCompleted()
                        } catch {
                            observer.onError(error)
                        }
                    case let .failure(error):
                        observer.onError(error)
                    }
            }
            
            return Disposables.create()
        }
    }
}

extension Formatter {
    static let iso8601withFractionalSeconds: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()
}

extension JSONDecoder.DateDecodingStrategy {
    static let customISO8601 = custom {
        let container = try $0.singleValueContainer()
        let string = try container.decode(String.self)
        if let date = Formatter.iso8601withFractionalSeconds.date(from: string) ?? Formatter.iso8601.date(from: string) {
            return date
        }
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(string)")
    }
}
