//
//  ProfilesReactor.swift
//  cached
//
//  Created by Marc Krenn on 04.10.22.
//

import SwiftUI
import AsyncReactor

class ProfilesReactor: AsyncReactor {
    
    @Published
    private(set) var state: State
    
    private let api: Service
    
    enum Action {
        case loadUsers
    }
    
    struct State {
        var users = AsyncLoad<[User]>.none
    }
    
    @MainActor
    func action(_ action: Action) async {
        switch action {
        case .loadUsers:
            
            do {
                
                state.users = .loadingWithCache(try await api.getUsers(loadWithCache: true))
//                state.users = .loading
                
                do {
                    state.users = .loaded(try await api.getUsers(loadWithCache: false))
                    
                    if let firstUserId = state.users.item?.first?.id {
                        do {
                            try await api.preCachePosts(userId: firstUserId)
                        } catch { }
                    }
                    
                } catch {
                    state.users = .error(error)
                    print("Error info: \(error)")
                }
                
            } catch {
                state.users = .error(error)
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
