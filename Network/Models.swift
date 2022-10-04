//
//  Models.swift
//  cached
//
//  Created by Marc Krenn on 04.10.22.
//

import Foundation

struct User: Codable, Hashable {
    let id: Int
    let name: String
}

struct Post: Codable, Hashable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

struct Comment: Codable, Hashable {
    let postId: Int
    let id: Int
    let name: String
    let email: String
    let body: String
}
