//
//  Models.swift
//  cached
//
//  Created by Marc Krenn on 04.10.22.
//

import Foundation

public struct User: Codable, Hashable {
    let id: Int
    let name: String
}

public extension Array where Element == User {
    static let mock: [User] = (1...10).map { User(id: $0, name: "\(randomString(length: Int.random(in: 15..<35)))") }
}

public struct Post: Codable, Hashable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

public extension Array where Element == Post {
    static let mock: [Post] = (1...10).map { Post(userId: 0, id: $0, title: "\(randomString(length: Int.random(in: 20..<35)))", body: "") }
}

public struct Comment: Codable, Hashable {
    let postId: Int
    let id: Int
    let name: String
    let email: String
    let body: String
}
