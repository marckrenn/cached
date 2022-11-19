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
        var users = AsyncLoad<GetUsers>.none
    }
    
    @MainActor
    func action(_ action: Action) async {
        switch action {
        case .loadUsers:
            
//            fetch(state: .users, call: api.getUsers(), policy: [.loadWithCache, .offlineCache]) {
//
//                $0.success {
//
//                }.error {
//
//                }
//
//            }
            
            do {
                
                state.users = .loadingWithCache(try await api.getUsersCached())
//                state.users = .loading
                
                do {
                    state.users = .loaded(try await api.getUsers())
                    
                    if let firstUserId = state.users.item?.first?.id {
                        do {
                            try await api.preCachePosts(userId: firstUserId)
                        } catch { }
                    }
                    
                } catch HTTPError<GetUsers>.noResponseWithCache(let error) {
                    state.users = .errorWithCache(error)
                    print("Error info: \(error)")
                }
                
            } catch {
                state.users = .error(error)
                print("Error info: \(error)")
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
