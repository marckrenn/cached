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
            
            state.users = .loading
            
            do {
                state.users = .loaded(try await api.getUsers())
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
