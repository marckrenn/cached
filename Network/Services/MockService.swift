//
//  MockService.swift
//  cached
//
//  Created by Marc Krenn on 04.10.22.
//

import Foundation

struct MockService: Service {
    
    struct MockError: LocalizedError {
        var errorDescription: String? {
            "loading failed"
        }
    }
    
    func getUsers(loadWithCache: Bool) async throws -> EndpointsResult<[User]> {
        return EndpointsResult(data: [], response: .init(), source: .none)
    }
    
    func getPosts(userId: Int, loadWithCache: Bool) async throws -> EndpointsResult<[Post]> {
        return EndpointsResult(data: [], response: .init(), source: .none)
    }
    
    func getComments(postId: Int, loadWithCache: Bool) async throws -> EndpointsResult<[Comment]> {
        return EndpointsResult(data: [], response: .init(), source: .none)
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
