//
//  PostListView.swift
//  cached
//
//  Created by Marc Krenn on 04.10.22.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostsListView: View {
    
    @EnvironmentObject
    var reactor: PostsReactor
    
    @State private var placeholderPosts: [Post] = []
    
    private func generatePlaceholderPosts(count: Int) -> [Post] {
        return (1...count).map {
            Post(userId: reactor.state.user?.id ?? 0, id: $0, title: "\(randomString(length: Int.random(in: 20..<35)))", body: "")
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            List {
                
                Section(header:
                            
                    Text("Recent blog posts")
                        .bold()
                        
                ) {
                    
                    ForEach(reactor.state.posts.item ?? placeholderPosts, id: \.id) { post in
                        NavigationLink(value: post) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(post.title)
                                    .lineLimit(1)
                                    .redacted(reason: reactor.state.posts.item == nil ? .placeholder : [])
                            }
                        }
                        
                    }
                    .disabled(reactor.state.posts.source == .none ? true : false)
                }
            }
//            .animation(.spring(), value: reactor.state.posts.item)
            .navigationDestination(for: Post.self) {
                ReactorView(CommentsReactor(state: CommentsReactor.State(post: $0))) { CommentsListView() }
                    .navigationTitle("Blog Post")
                    .navigationBarTitleDisplayMode(.inline)
            }
            
            StateBarView(state: reactor.state.posts,
                         onTap: { Task { await reactor.action(.loadPosts) }})
        }
        
        .onAppear {
            
            placeholderPosts = generatePlaceholderPosts(count: 10)
            
            Task {
                await reactor.action(.loadPosts)
            }
        }
        .refreshable {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                Task {
                    await reactor.action(.loadPosts)
                }
            }
        }
        
    }
}

//struct PostListView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostsListView()
//    }
//}
