//
//  Config.swift
//  cached
//
//  Created by Marc Krenn on 04.10.22.
//

import Foundation
import Endpoints

let Config: AppConfig = LiveConfig()

protocol AppConfig {
    var remoteService: Service { get }
}

struct LiveConfig: AppConfig {
    let remoteService: Service = RemoteService()
}

struct MockConfig: AppConfig {
    let remoteService: Service = MockService()
}
