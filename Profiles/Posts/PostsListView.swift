//
//  PostListView.swift
//  cached
//
//  Created by Marc Krenn on 04.10.22.
//

import SwiftUI

struct PostsListView: View {
    
    @EnvironmentObject
    var reactor: PostsReactor
    
    var body: some View {
        VStack(spacing: 0) {
            
            List {
                
                Section(header:
                            
                            Text("Recent blog posts")
                    .bold()
                        
                ) {
                    
                    ForEach(reactor.state.posts.item ?? [], id: \.id) { post in
                        NavigationLink(value: post) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(post.title)
                                    .lineLimit(1)
                                    .redacted(reason: reactor.state.posts.source == .placeholder ? .placeholder : [])
                            }
                        }
                        
                    }
                    .disabled(reactor.state.posts.source == .none || reactor.state.posts.source == .placeholder ? true : false)
                }
            }
            .navigationDestination(for: Post.self) {
                ReactorView(CommentsReactor(state: CommentsReactor.State(post: $0))) { CommentsListView() }
                    .navigationTitle("Blog Post")
                    .navigationBarTitleDisplayMode(.inline)
            }
            
        }
        .toolbar {
            Button(action: { Task { await reactor.action(.loadPosts) } }) {
                Image(systemName: "goforward")
            }
            .disabled(reactor.state.posts.isLoading)
        }
        
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                StateBarView(state: reactor.state.posts,
                             onTap: { Task { await reactor.action(.loadPosts) }})
            }
        }
        
        .onAppear {
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
