//
//  Misc.swift
//  cached
//
//  Created by Marc Krenn on 04.10.22.
//

import Foundation
import Endpoints

class CustomJSONParser<T: Decodable>: JSONParser<T> {
    override var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFractionalSeconds, .withInternetDateTime]

        decoder.dateDecodingStrategy = .custom({ decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            if let date = formatter.date(from: dateString) {
                return date
            }
            
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
        })
        
        return decoder
    }
}

extension Encodable where Self: Body {
    public var header: Parameters? {
        ["Content-Type": "application/json"]
    }

    public var requestData: Data {
        (try? JSONEncoder().encode(self)) ?? Data()
    }
}
