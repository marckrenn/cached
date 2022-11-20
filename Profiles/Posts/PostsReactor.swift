//
//  PostsReactor.swift
//  cached
//
//  Created by Marc Krenn on 04.10.22.
//

import SwiftUI
import AsyncReactor
import Endpoints

class PostsReactor: AsyncReactor {
    
    @Published
    private(set) var state: State
    
    private let api: Service
    
    enum Action {
        case loadPosts
    }
    
    struct State {
        var user: User?
        var posts = AsyncLoad<GetPosts>.placeholder(.mock)
    }
    
    @MainActor
    func action(_ action: Action) async {
        switch action {
        case .loadPosts:
            
            loading(state: &state.posts, withPlaceholder: .mock)
            
            do {
                
                state.posts = .loadingWithCache(try await api.getPostsCached(userId: state.user?.id ?? 0))
                
                do {
                    state.posts = .loaded(try await api.getPosts(userId: state.user?.id ?? 0))
                    
                    if let firstPostId = state.posts.item?.first?.id {
                        do {
                            try await api.preCacheComments(postId: firstPostId)
                        } catch { }
                    }
                    
                } catch HTTPError<GetPosts>.noResponseWithCache(let error) {
                    state.posts = .errorWithCache(error)
                }
                
            } catch {
                state.posts = .errorWithPlaceholder((.mock, error))
            }
            
        }
    }
    
    @MainActor
    init(api: Service = Config.remoteService, state: State = State()) {
        self.api = api
        self.state = state
    }
    
}
