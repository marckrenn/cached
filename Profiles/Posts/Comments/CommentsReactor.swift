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
            
            state.comments = .loading
            
            do {
                state.comments = .loaded(try await api.getComments(postId: state.post?.id ?? 0))
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
