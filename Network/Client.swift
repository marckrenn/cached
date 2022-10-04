//
//  Client.swift
//  cached
//
//  Created by Marc Krenn on 04.10.22.
//

import Foundation
import Endpoints

class Client: AnyClient {

    init() {
        super.init(baseURL: URL(string: "https://jsonplaceholder.typicode.com/")!)
    }

    override func encode<C>(call: C) -> URLRequest where C: Call {
        return super.encode(call: call)
    }
}
