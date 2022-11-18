//
//  CommentsReactor.swift
//  cached
//
//  Created by Marc Krenn on 04.10.22.
//

import SwiftUI
import AsyncReactor

class CommentsReactor: AsyncReactor {
    
    @Published
    private(set) var state: State
    
    private let api: Service
    
    enum Action {
        case loadComments
    }
    
    struct State {
        var post: Post?
        var comments = AsyncLoad<[Comment]>.none
    }
    
    @MainActor 
    func action(_ action: Action) async {
        switch action {
        case .loadComments:
            
            do {
                
                state.comments = .loadingWithCache(try await api.getComments(postId: state.post?.id ?? 0, loadWithCache: true))
//                state.comments = .loading
                
                do {
                    state.comments = .loaded(try await api.getComments(postId: state.post?.id ?? 0, loadWithCache: false))
                } catch {
                    state.comments = .error(error)
                    print("Error info: \(error)")
                }
                
            } catch {
                state.comments = .error(error)
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
