//
//  Network.swift
//  flexday
//
//  Created by inchan on 14/04/2021.
//  Copyright © 2021 flexday korea. All rights reserved.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift
import RxCocoa
import NSObject_Rx
import SDWebImage

public enum Result<Value, Error> {
    
    case success(Value)
    case failure(Error)
    
    init(value: Value) { self = .success(value) }
    init(error: Error) { self = .failure(error) }
    
    var value: Value? {
        switch self {
        case .success(let value):
            return value
        default:
            return nil
        }
    }
    
    var error: Error? {
        switch self {
        case .failure(let error):
            return error
        default:
            return nil
        }
    }
}

public struct APIError {
    var displayMessage: String?
    var error: Error?
    var description: String?
    var errorResponse: APIErrorResponse?
        
    init(_ message: String) {
        description = message
        displayMessage = message
    }
    
    init(_ error: Error, message: String? = nil) {
        description = error.localizedDescription
        if let message = message {
            displayMessage = message
        }
    }
    
    init(_ response: APIErrorResponse, error: Error? = nil) {
        description =
        """
        <\(response.response.url?.absoluteString ?? "not url ???")>
        satusCode: \(response.response.statusCode)
        data langth: \(response.data.count)
        data string: \(String(data: response.data, encoding: .utf8) ?? "")
        """
        self.error = error
        self.errorResponse = response
    }
}

struct APIErrorResponse {
    let response: HTTPURLResponse
    let data: Data
}

class NetworkService: NSObject {
    
    static let shared = NetworkService()
    static var server: ServerConfiguration? = nil;

    let isDebug = true
    
    let sessionManager: Session = {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 8
        configuration.timeoutIntervalForResource = 8
        return Session(configuration: configuration)
    }()

    func request<T: Codable>(ofType: T.Type, method: HTTPMethod = .post, url: URLConvertible, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.queryString, header: HTTPHeaders? = nil, completion: ((Result<T, APIError>) -> Void)? = nil ) {
        sessionManager.rx
            .request(method, url, parameters: parameters, encoding: encoding, headers: header)
            .debug("[\((try? url.asURL().lastPathComponent) ?? "")]", trimOutput: false)
            .responseData()
            .expectingObject(ofType: ofType)
            .subscribe({ (event) in
                switch event {
                case .next(let result):
                    if NetworkService.shared.isDebug {
                        dump(result)
                    }
                    completion?(result)
                    break
                case .error(let error):
                    completion?(.failure(.init(error)))
                    break
                default:
                    break
                }
            })
            .disposed(by: rx.disposeBag)
    }

    func request<R: APIRequestable>(_ reqeust: R, completion: R.ResultBlock? = nil) {
        request(ofType: R.ModelType.self, method: reqeust.method, url: reqeust.url.publishURL, parameters: reqeust.parameters, encoding:reqeust.encoding, header: reqeust.header, completion: completion)
    }

}

extension Observable where Element == (HTTPURLResponse, Data){
    fileprivate func expectingObject<T : Codable>(ofType type: T.Type) -> Observable<Result<T, APIError>>{
        return self.map { (httpURLResponse, data) -> Result<T, APIError> in
            let response = APIErrorResponse(response: httpURLResponse, data: data)
            switch httpURLResponse.statusCode{
            case 200 ... 299:
                // is status code is successful we can safely decode to our expected type T
                do {
                    let decodedObject = try JSONDecoder().decode(type, from: data)
                    return .success(decodedObject)
                }
                catch (let error) {
                    let error = APIError(response, error: error)
                    return .failure(error)
                }
            default:
                let error = APIError(response)
                return .failure(error)
            }
        }
    }
}

