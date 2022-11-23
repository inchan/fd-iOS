//
//  APIRequestable.swift
//  flexday
//
//  Created by inchan on 14/04/2021.
//  Copyright © 2021 flexday korea. All rights reserved.
//

import Foundation
import Alamofire

struct APIRequestURL {
    var url: String
    var paths: [String] = []
    var querys: [String: String] = [:]
    
    var publishURL: URL {
        if var components = URLComponents(string: url) {
            components.path = paths.joined(separator: "/")
            var queryItems = components.queryItems ?? []
            let newQueryItems = querys.map({ URLQueryItem(name: $0.key, value: $0.value) })
            queryItems.append(contentsOf: newQueryItems)
            components.queryItems = queryItems
            if let url = components.url {
                return url
            }
        }
        return URL(string: url)!
    }
}

protocol APIRequestable {

    associatedtype ModelType: Codable
    typealias ResultType = Result<ModelType, APIError>
    typealias ResultBlock = (ResultType) -> Void

    var url: APIRequestURL { get }
    var parameters: [String: String]? { get set }
    var method: HTTPMethod { get }
    var encoding: ParameterEncoding { get }
    var header: HTTPHeaders? { get }
    
    func request(completion: ResultBlock?)
    
    init()
}

// defalut set
extension APIRequestable {
    
    var path: [String] {
        return []
    }

    var querys: [String: String] {
        return [:]
    }
    
    var method: HTTPMethod {
        return .get
    }

    var parameters: [String: String]? {
        return nil
    }
    
    var encoding: ParameterEncoding {
        return URLEncoding.queryString
    }
    
    var header: HTTPHeaders? {
        return nil
    }
        
    func request(completion: ResultBlock? = nil) {
        NetworkService.shared.request(self, completion: completion)
    }
    
    init() {
        self.init()
    }
}

