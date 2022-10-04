//
//  PostsReactor.swift
//  cached
//
//  Created by Marc Krenn on 04.10.22.
//

import SwiftUI
import AsyncReactor

class PostsReactor: AsyncReactor {
    
    @Published
    private(set) var state: State
    
    private let api: Service
    
    enum Action {
        case loadPosts
    }
    
    struct State {
        var user: User?
        var posts = AsyncLoad<[Post]>.none
    }
    
    @MainActor
    func action(_ action: Action) async {
        switch action {
        case .loadPosts:
            
            state.posts = .loading
            
            do {
                state.posts = .loaded(try await api.getPosts(userId: state.user?.id ?? 0))
            } catch {
                print("Error info: \(error)")
            }
        }
    }
    
    @MainActor
    init(api: Service = Config.remoteService, state: State = State()) {
        self.api = api
        self.state = state
    }
    
}
