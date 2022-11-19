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
    
    func removeAllCachedResponses() {
        session.urlSession.configuration.urlCache?.removeAllCachedResponses()
    }
    
    
    func getUsers() async throws -> HTTPResult<GetUsers> {
        try await makeCall(GetUsers())
    }
    
    func getUsersCached() async throws -> HTTPResult<GetUsers> {
        try await getCache(GetUsers())
    }
    
    
    func getPosts(userId: Int) async throws -> HTTPResult<GetPosts> {
        try await makeCall(GetPosts(userId: userId))
    }
    
    func getPostsCached(userId: Int) async throws -> HTTPResult<GetPosts> {
        try await getCache(GetPosts(userId: userId))
    }
    
    
    func getComments(postId: Int) async throws -> HTTPResult<GetComments> {
        try await makeCall(GetComments(postId: postId))
    }
    
    func getCommentsCached(postId: Int) async throws -> HTTPResult<GetComments> {
        try await getCache(GetComments(postId: postId))
    }
    
    
    func preCachePosts(userId: Int) async throws -> Void {
        try await preCacheCall(GetPosts(userId: userId), cachePolicy: .reloadRevalidatingCacheData)
    }
    
    func preCacheComments(postId: Int) async throws -> Void {
        try await preCacheCall(GetComments(postId: postId), cachePolicy: .reloadRevalidatingCacheData)
    }
    
}

extension RemoteService {
    private func makeCall<C: Call>(_ call: C,
                                   offlineCaching: Bool = true,
                                   cachePolicy: NSURLRequest.CachePolicy = .reloadIgnoringLocalCacheData) async throws -> HTTPResult<C> {
        let response = try await session.start(call: call, loadWidthCache: false, offlineCaching: offlineCaching, cachePolicy: cachePolicy)
        return HTTPResult(value: response.0 as C.Parser.OutputType, response: response.1, source: response.2)
    }
    
    private func getCache<C: Call>(_ call: C,
                                   cachePolicy: NSURLRequest.CachePolicy = .reloadRevalidatingCacheData) async throws -> HTTPResult<C> {
        let response = try await session.start(call: call, loadWidthCache: true, offlineCaching: false, cachePolicy: cachePolicy)
        return HTTPResult(value: response.0 as C.Parser.OutputType, response: response.1, source: response.2)
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
