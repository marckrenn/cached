//
//  ContentView.swift
//  cached
//
//  Created by Marc Krenn on 29.09.22.
//

import SwiftUI

struct ProfilesListView: View {
    
    @EnvironmentObject
    var reactor: ProfilesReactor
    
    @State private var placeholderUser: [User] = []
    @State private var showingCacheAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            
            List {
                
                ForEach(reactor.state.users.item ?? .mock, id: \.id) { user in
                    NavigationLink(value: user) {
                        Text(user.name)
                            // Required for placeholder
                            .redacted(reason: reactor.state.users.source == .placeholder ? .placeholder : [])
                    }
                    
                }
                .disabled(reactor.state.users.source == .none || reactor.state.users.source == .placeholder ? true : false)
            }
            .navigationDestination(for: User.self) {
                ReactorView(PostsReactor(state: PostsReactor.State(user: $0))) { PostsListView() }
                    .navigationTitle("\($0.name)'s")
            }
            
        }
        
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                StateBarView(state: reactor.state.users,
                             onTap: { Task { await reactor.action(.loadUsers) }})
            }
        }
        
        .onAppear {
            Task {
                await reactor.action(.loadUsers)
            }
        }
        .refreshable {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                Task {
                    await reactor.action(.loadUsers)
                }
            }
            
        }
        .toolbar {
            ToolbarItemGroup {
                
                Button(action: { showingCacheAlert.toggle() }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                
                Button(action: { Task { await reactor.action(.loadUsers) } }) {
                    Image(systemName: "goforward")
                }
                .disabled(reactor.state.users.isLoading)
                
            }
        }
        .alert("Cache",
               isPresented: $showingCacheAlert,
               actions: {
            Button("Cancel", role: .cancel) { }
            Button("Remove", role: .destructive) {
                Task {
                    await reactor.action(.removeAllCachedResponses)
                }}
        }, message: { Text("Remove all cached responses?") })
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilesListView()
    }
}
