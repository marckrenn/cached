//
//  Service.swift
//  cached
//
//  Created by Marc Krenn on 04.10.22.
//

import Foundation

protocol Service {
    func getUsers(loadWithCache: Bool) async throws -> EndpointsResult<[User]>
    func getPosts(userId: Int, loadWithCache: Bool) async throws -> EndpointsResult<[Post]>
    func getComments(postId: Int, loadWithCache: Bool) async throws -> EndpointsResult<[Comment]>
    
    func preCachePosts(userId: Int) async throws -> Void
    func preCacheComments(postId: Int) async throws -> Void
    
//    func getUsers() async throws -> [User]
//    func getPosts(userId: Int) async throws -> [Post]
//    func getComments(postId: Int) async throws -> [Comment]
    
//    func getUsersCached() async throws -> [User]
//    func getPostsCached(userId: Int) async throws -> [Post]
//    func getCommentsCached(postId: Int) async throws -> [Comment]
}
