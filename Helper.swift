//
//  Helper.swift
//  cached
//
//  Created by Marc Krenn on 20.11.22.
//

import Foundation
import Endpoints

public func randomString(length: Int = 20) -> String {
    let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    var randomString: String = ""
    
    for _ in 0..<length {
        let randomValue = arc4random_uniform(UInt32(base.count))
        randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
    }
    return randomString
}

func loading<C: Call>(state: inout AsyncLoad<C>, withPlaceholder: C.Parser.OutputType) {
    if state.source == .none || state.source == .placeholder {
        state = .loadingWithPlaceholder(withPlaceholder)
    }
}
