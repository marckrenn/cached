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
    
    func getUsers() async throws -> [User] {
        return []
    }
    
    func getPosts(userId: Int) async throws -> [Post] {
        return []
    }
    
    func getComments(postId: Int) async throws -> [Comment] {
        return []
    }
    
}
