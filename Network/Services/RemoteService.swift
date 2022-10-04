//
//  RemoteService.swift
//  cached
//
//  Created by Marc Krenn on 04.10.22.
//

import Foundation
import Endpoints

struct RemoteService: Service {
    
    enum ServiceError: Error {
        case notImplemented
        case noValue
    }
    
    let session: Session<Client> = {
        let sessionConfig = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: sessionConfig)
        let session = Session(with: Client(), using: urlSession)
        
#if DEBUG
        session.debug = true
#endif
        return session
    }()
    
    
    func getUsers() async throws -> [User] {
        try await makeCall(GetUsers())
    }
    
    func getPosts(userId: Int) async throws -> [Post] {
        try await makeCall(GetPosts(userId: userId))
    }
    
    func getComments(postId: Int) async throws -> [Comment] {
        try await makeCall(GetComments(postId: postId))
    }
    
}

extension RemoteService {
    private func makeCall<C: Call, Data: Decodable>(_ call: C) async throws -> Data where C.Parser.OutputType == Data {
        try await session.start(call: call).0
    }
    
    private func makeCall<C: Call>(_ call: C) async throws where C.Parser.OutputType == Void {
        try await session.start(call: call).0
    }
    
}
