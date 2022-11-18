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
        sessionConfig.timeoutIntervalForRequest = 5
        
        let cache = URLCache(memoryCapacity: 30 * 1024 * 1024, diskCapacity: 25 * 1024 * 1024, directory: nil)
        sessionConfig.urlCache = cache
        let urlSession = URLSession(configuration: sessionConfig)
        let session = Session(with: Client(), using: urlSession)
        
#if DEBUG
        session.debug = true
#endif
        return session
    }()
    
    
    func getUsers(loadWithCache: Bool) async throws -> EndpointsResult<[User]> {
        try await makeCall(GetUsers(), loadWidthCache: loadWithCache)
    }
    
    func getPosts(userId: Int, loadWithCache: Bool) async throws -> EndpointsResult<[Post]> {
        try await makeCall(GetPosts(userId: userId), loadWidthCache: loadWithCache)
    }

    func getComments(postId: Int, loadWithCache: Bool) async throws -> EndpointsResult<[Comment]> {
        try await makeCall(GetComments(postId: postId), loadWidthCache: loadWithCache)
    }
    
    func preCachePosts(userId: Int) async throws -> Void {
        try await preCacheCall(GetPosts(userId: userId), cachePolicy: .reloadRevalidatingCacheData)
    }
    
    func preCacheComments(postId: Int) async throws -> Void {
        try await preCacheCall(GetComments(postId: postId), cachePolicy: .reloadRevalidatingCacheData)
    }

    
//    func getUsers() async throws -> [User] {
//        try await makeCall(GetUsers())
//    }
//
//    func getPosts(userId: Int) async throws -> [Post] {
//        try await makeCall(GetPosts(userId: userId))
//    }
//
//    func getComments(postId: Int) async throws -> [Comment] {
//        try await makeCall(GetComments(postId: postId))
//    }
//
//
//    func getUsersCached() async throws -> [User] {
//        try await cachedResponse(GetUsers())
//    }
//
//    func getPostsCached(userId: Int) async throws -> [Post] {
//        try await cachedResponse(GetPosts(userId: userId))
//    }
//
//    func getCommentsCached(postId: Int) async throws -> [Comment] {
//        try await cachedResponse(GetComments(postId: postId))
//    }
    
}

public class EndpointsResult<T> {
    internal init(data: T, response: HTTPURLResponse, source: HttpSource) {
        self.data = data
        self.response = response
        self.source = source
    }
    
    let data: T
    let response: HTTPURLResponse
    let source: HttpSource
}

extension RemoteService {
    private func makeCall<C: Call>(_ call: C,
                                   loadWidthCache: Bool,
                                   offlineCaching: Bool = true,
                                   cachePolicy: NSURLRequest.CachePolicy = .reloadIgnoringLocalCacheData) async throws -> EndpointsResult<C.Parser.OutputType> {
        let response = try await session.start(call: call, loadWidthCache: loadWidthCache, offlineCaching: offlineCaching, cachePolicy: cachePolicy)
        return EndpointsResult(data: response.0 as C.Parser.OutputType, response: response.1, source: response.2)
    }
    
    private func preCacheCall<C: Call>(_ call: C, cachePolicy: NSURLRequest.CachePolicy = .returnCacheDataElseLoad) async throws -> Void {
        let _ = try await session.start(call: call, loadWidthCache: true, offlineCaching: false, cachePolicy: cachePolicy)

    }
    
    // TODO: makeCall that returns Void
    
    //    private func makeCall<C: Call, Data: Decodable>(_ call: C) async throws -> Data where C.Parser.OutputType == Data {
    //        let foo = try await session.start(call: call)
    //        print(foo.2)
    //        return foo.0
    //    }
    
//    private func makeCall<C: Call>(_ call: C) async throws where C.Parser.OutputType == Void {
//        try await session.start(call: call).0
//    }
//
//    private func cachedResponse<C: Call, Data: Decodable>(_ call: C) async throws -> Data where C.Parser.OutputType == Data {
//        let foo = try await session.cachedResponse(call: call)
//        print(foo.2)
//        return foo.0
//    }
//
//    private func cachedResponse<C: Call>(_ call: C) async throws where C.Parser.OutputType == Void {
//        try await session.cachedResponse(call: call).0
//    }
//
//    private func makeCall<C: Call, Data: Decodable>(_ call: C) async throws -> Data where C.Parser.OutputType == Data {
//        let foo = try await session.start(call: call)
//        print(foo.2)
//        return foo.0
//    }
    
}
