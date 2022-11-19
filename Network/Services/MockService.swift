//
//  MockService.swift
//  cached
//
//  Created by Marc Krenn on 04.10.22.
//

import Foundation
import Endpoints

struct MockService: Service {
    
    struct MockError: LocalizedError {
        var errorDescription: String? {
            "loading failed"
        }
    }
    
    func removeAllCachedResponses() { }
    
    func getUsers() async throws -> HTTPResult<GetUsers> {
        return HTTPResult(value: [], response: .init(), source: .none)
    }
    
    func getUsersCached() async throws -> HTTPResult<GetUsers> {
        return HTTPResult(value: [], response: .init(), source: .none)
    }
    
    
    func getPosts(userId: Int) async throws -> HTTPResult<GetPosts> {
        return HTTPResult(value: [], response: .init(), source: .none)
    }
    
    func getPostsCached(userId: Int) async throws -> HTTPResult<GetPosts> {
        return HTTPResult(value: [], response: .init(), source: .none)
    }
    
    
    func getComments(postId: Int) async throws -> HTTPResult<GetComments> {
        return HTTPResult(value: [], response: .init(), source: .none)
    }
    
    func getCommentsCached(postId: Int) async throws -> HTTPResult<GetComments> {
        return HTTPResult(value: [], response: .init(), source: .none)
    }
    
    
    func preCachePosts(userId: Int) async throws { }
    
    func preCacheComments(postId: Int) async throws { }
    
//    func getUsers() async throws -> [User] {
//        return []
//    }
    
//    func getPosts(userId: Int) async throws -> [Post] {
//        return []
//    }
//
//    func getComments(postId: Int) async throws -> [Comment] {
//        return []
//    }
//
//
//    func getUsersCached() async throws -> [User] {
//        return []
//    }
//
//    func getPostsCached(userId: Int) async throws -> [Post] {
//        return []
//    }
//
//    func getCommentsCached(postId: Int) async throws -> [Comment] {
//        return []
//    }
    
}
