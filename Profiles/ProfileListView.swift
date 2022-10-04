//
//  ContentView.swift
//  cached
//
//  Created by Marc Krenn on 29.09.22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfilesListView: View {
    
    @EnvironmentObject
    var reactor: ProfilesReactor
    
    var body: some View {
        VStack {
            
            List {
                
                ForEach(reactor.state.users.item ?? [], id: \.id) { user in
                    NavigationLink(value: user) {
                        Text(user.name)
                    }
                    
                }
            }
            .navigationDestination(for: User.self) {
                ReactorView(PostsReactor(state: PostsReactor.State(user: $0))) { PostsListView() }
                    .navigationTitle("\($0.name)")
            }
            
        }
        //        .animation(.spring(), value: reactor.state.users)
        .onAppear {
            Task {
                await reactor.action(.loadUsers)
            }
        }
        .refreshable {
            Task {
                await reactor.action(.loadUsers)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if reactor.state.users.isLoading {
                    ActivityIndicator(.constant(true), style: .medium)
                }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilesListView()
    }
}
