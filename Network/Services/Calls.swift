//
//  Calls.swift
//  cached
//
//  Created by Marc Krenn on 04.10.22.
//

import Foundation
import Endpoints

struct GetUsers: Call {
    typealias Parser = CustomJSONParser<[User]>
    
    var request: URLRequestEncodable {
        Request(.get, "users")
    }
}

struct GetPosts: Call {
    typealias Parser = CustomJSONParser<[Post]>
    let userId: Int
    
    var request: URLRequestEncodable {
        Request(.get, "posts", query: ["userId": String(userId)])
    }
}

struct GetComments: Call {
    typealias Parser = CustomJSONParser<[Comment]>
    let postId: Int
    
    var request: URLRequestEncodable {
        Request(.get, "comments", query: ["postId": String(postId)])
    }
}
