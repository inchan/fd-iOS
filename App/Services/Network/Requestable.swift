//
//  Requestable.swift
//  flexday
//
//  Created by inchan on 14/04/2021.
//  Copyright © 2021 flexday korea. All rights reserved.
//

import Foundation
import Alamofire

struct RequestURL {
    var url: String
    var paths: [String] = []
    var querys: [String: String] = [:]
    
    var publishURL: URL {
        if var components = URLComponents(string: url) {
            var paths: [String] = components.path.count > 0 ? [components.path] : []
            paths.append(contentsOf: self.paths)
            var newPath = paths.joined(separator: "/")
            if newPath.hasPrefix("/") == false {
                newPath.insert("/", at: newPath.startIndex)
            }
            components.path = newPath
            var queryItems = components.queryItems ?? []
            let newQueryItems = querys.map({ URLQueryItem(name: $0.key, value: $0.value) })
            queryItems.append(contentsOf: newQueryItems)
            components.queryItems = queryItems.count > 0 ? queryItems : nil
            if let url = components.url {
                return url
            }
        }
        return URL(string: url)!
    }
}

protocol Requestable {

    associatedtype ModelType: Codable
    typealias ResultType = Result<ModelType, APIError>
    typealias ResultBlock = (ResultType) -> Void

    var url: RequestURL { get }
    var parameters: [String: String]? { get set }
    var method: HTTPMethod { get }
    var encoding: ParameterEncoding { get }
    var header: HTTPHeaders? { get }
    
    func request(completion: ResultBlock?)
    
    init()
}

// defalut set
extension Requestable {
        
    var method: HTTPMethod {
        return .get
    }

    var parameters: [String: String]? {
        return [:]
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

