//
//  CommentsListView.swift
//  cached
//
//  Created by Marc Krenn on 04.10.22.
//

import SwiftUI
import SDWebImageSwiftUI

struct CommentsListView: View {
    
    @EnvironmentObject
    var reactor: CommentsReactor
    
    var body: some View {
        VStack {
            
            List {
                
                Text(reactor.state.post?.body ?? "")
                
                Text("\((reactor.state.comments.item ?? []).count) comments:")
                    .bold()
                
                ForEach(reactor.state.comments.item ?? [], id: \.id) { comment in
                    VStack(alignment: .leading, spacing: 5) {
                        Text(comment.body)
                        Text("By: \(comment.email)")
                            .font(.caption)
                    }
                    
                }
            }
            
        }
        //        .animation(.spring(), value: reactor.state.users)
        .onAppear {
            Task {
                await reactor.action(.loadComments)
            }
        }
        .refreshable {
            Task {
                await reactor.action(.loadComments)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if reactor.state.comments.isLoading {
                    ActivityIndicator(.constant(true), style: .medium)
                }
            }
        }
        
    }
}

struct CommentsListView_Previews: PreviewProvider {
    static var previews: some View {
        CommentsListView()
    }
}
