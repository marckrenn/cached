//
//  Service.swift
//  cached
//
//  Created by Marc Krenn on 04.10.22.
//

import Foundation
import Endpoints

protocol Service {
    
    func removeAllCachedResponses()
    
    func getUsers() async throws -> EndpointsResult<[User]>
    func getUsersCached() async throws -> EndpointsResult<[User]>
    
    func getPosts(userId: Int) async throws -> EndpointsResult<[Post]>
    func getPostsCached(userId: Int) async throws -> EndpointsResult<[Post]>
    
    func getComments(postId: Int) async throws -> EndpointsResult<[Comment]>
    func getCommentsCached(postId: Int) async throws -> EndpointsResult<[Comment]>
    
    func preCachePosts(userId: Int) async throws -> Void
    func preCacheComments(postId: Int) async throws -> Void
    
//    func getUsers() async throws -> [User]
//    func getPosts(userId: Int) async throws -> [Post]
//    func getComments(postId: Int) async throws -> [Comment]
    
//    func getUsersCached() async throws -> [User]
//    func getPostsCached(userId: Int) async throws -> [Post]
//    func getCommentsCached(postId: Int) async throws -> [Comment]
}
