//
//  CodableExtension.swift
//  flexday
//
//  Created by inchan on 2021/04/22.
//  Copyright © 2021 Enliple. All rights reserved.
//

import Foundation

extension Decodable {

    static func decode(with data: Data) -> Self? {
        return try? JSONDecoder().decode(Self.self, from: data)
    }
    
    static func decode(with json: String) -> Self? {
        guard let data = json.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(Self.self, from: data)
    }
}

extension Encodable {
    
    var asJsonString: String? {
        return asData?.string(encoding: .utf8)
    }
    
    var asData: Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return try? encoder.encode(self)
    }
}
