//
//  Service.swift
//  cached
//
//  Created by Marc Krenn on 04.10.22.
//

import Foundation

protocol Service {
    func getUsers() async throws -> [User]
    func getPosts(userId: Int) async throws -> [Post]
    func getComments(postId: Int) async throws -> [Comment]
}
