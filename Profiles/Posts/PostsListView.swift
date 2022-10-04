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
    
    var body: some View {
        VStack {
            
            List {
                
                ForEach(reactor.state.posts.item ?? [], id: \.id) { post in
                    NavigationLink(value: post) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(post.title.uppercased())
                                .font(.title2)
                                .lineLimit(2)
                            Text(post.body)
                        }
                    }
                    
                }
            }
            .navigationDestination(for: Post.self) {
                ReactorView(CommentsReactor(state: CommentsReactor.State(post: $0))) { CommentsListView() }
                    .navigationTitle("\($0.title)")
            }
            
        }
        //        .animation(.spring(), value: reactor.state.users)
        .onAppear {
            Task {
                await reactor.action(.loadPosts)
            }
        }
        .refreshable {
            Task {
                await reactor.action(.loadPosts)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if reactor.state.posts.isLoading {
                    ActivityIndicator(.constant(true), style: .medium)
                }
            }
        }
        
    }
}

struct PostListView_Previews: PreviewProvider {
    static var previews: some View {
        PostsListView()
    }
}
