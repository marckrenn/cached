//
//  ContentView.swift
//  cached
//
//  Created by Marc Krenn on 29.09.22.
//

import SwiftUI
import SDWebImageSwiftUI

public func randomString(length: Int = 20) -> String {
    let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    var randomString: String = ""

    for _ in 0..<length {
        let randomValue = arc4random_uniform(UInt32(base.count))
        randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
    }
    return randomString
}

struct ProfilesListView: View {
    
    @EnvironmentObject
    var reactor: ProfilesReactor
    
    @State private var placeholderUser: [User] = []
    
    private func generatePlaceholderUsers(count: Int) -> [User] {
        return (1...count).map {
            User(id: $0, name: "\(randomString(length: Int.random(in: 10..<35)))")
        }
        
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            List {
                
                ForEach(reactor.state.users.item ?? placeholderUser, id: \.id) { user in
                    NavigationLink(value: user) {
                        Text(user.name)
                            .redacted(reason: reactor.state.users.item == nil ? .placeholder : [])
                    }
                    
                }
                .disabled(reactor.state.users.source == .none ? true : false)
            }
//            .animation(.spring(), value: reactor.state.users.item)
            .navigationDestination(for: User.self) {
                ReactorView(PostsReactor(state: PostsReactor.State(user: $0))) { PostsListView() }
                    .navigationTitle("\($0.name)'s")
            }
            

            StateBarView(state: reactor.state.users,
                         onTap: { Task { await reactor.action(.loadUsers) }})
            
        }
        
        .onAppear {
            
            placeholderUser = generatePlaceholderUsers(count: 10)
            
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
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilesListView()
    }
}
