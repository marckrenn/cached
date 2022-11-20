//
//  ProfilesReactor.swift
//  cached
//
//  Created by Marc Krenn on 04.10.22.
//

import SwiftUI
import AsyncReactor
import Endpoints

class ProfilesReactor: AsyncReactor {
    
    @Published
    private(set) var state: State
    
    private let api: Service
    
    enum Action {
        case loadUsers
        case removeAllCachedResponses
    }
    
    struct State {
        var users = AsyncLoad<GetUsers>.placeholder(.mock)
    }
    
    @MainActor
    func action(_ action: Action) async {
        switch action {
        case .loadUsers:
            
            // Required for placeholder
            loading(state: &state.users, withPlaceholder: .mock)
            
            do {
                
                // Required for offline-caching
                state.users = .loadingWithCache(try await api.getUsersCached())
//                state.users = .loading
                
                do {
                    
                    state.users = .loaded(try await api.getUsers())
                    
                    // Pre-Cache
                    if let firstUserId = state.users.item?.first?.id {
                        do {
                            try await api.preCachePosts(userId: firstUserId)
                        } catch { }
                    }
                    
                // Required for offline-caching
                } catch HTTPError<GetUsers>.noResponseWithCache(let error) {
                    state.users = .errorWithCache(error)
                }
                
            } catch {
                // Required for placeholder
                state.users = .errorWithPlaceholder((.mock, error))
            }
            
        case .removeAllCachedResponses: api.removeAllCachedResponses()
        }
    }
    
    @MainActor
    init(api: Service = Config.remoteService, state: State = State()) {
        self.api = api
        self.state = state
    }
    
}
