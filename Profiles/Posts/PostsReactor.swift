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
        var posts = AsyncLoad<GetPosts>.none
    }
    
    @MainActor
    func action(_ action: Action) async {
        switch action {
        case .loadPosts:
            
            do {
                
                state.posts = .loadingWithCache(try await api.getPosts(userId: state.user?.id ?? 0, loadWithCache: true))
//                state.posts = .loading
                
                do {
//                    state.posts = .loaded(try await api.getPosts(userId: state.user?.id ?? 0))
                    state.posts = .loaded(try await api.getPosts(userId: state.user?.id ?? 0, loadWithCache: false))
                    
                    if let firstPostId = state.posts.item?.first?.id {
                        do {
                            try await api.preCacheComments(postId: firstPostId)
                        } catch { }
                    }
                    
                } catch HttpError<GetPosts>.NoResponseWithCache(let error) {
                    state.posts = .errorWithCache(error)
                    print("Error info: \(error)")
                }
                
            } catch {
                state.posts = .error(error)
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
