//
//  APIRequestable.swift
//  flexday
//
//  Created by inchan on 14/04/2021.
//  Copyright © 2021 flexday korea. All rights reserved.
//

import Foundation
import Alamofire

protocol APIRequestable {

    associatedtype ModelType: Codable
    typealias ResultType = Result<ModelType, APIError>
    typealias ResultBlock = (ResultType) -> Void

    var url: String { get }
    var parameters: [String: String]? { get set }
    var method: HTTPMethod { get }
    var encoding: ParameterEncoding { get }
    var header: HTTPHeaders? { get }
    
    func request(completion: ResultBlock?)
    
    init()
}

// defalut set
extension APIRequestable {
    
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

