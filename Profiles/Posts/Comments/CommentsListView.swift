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
    
    private var commentCount: String { (reactor.state.comments.item ?? []).count == 0 ? "?" : String((reactor.state.comments.item ?? []).count)
}
    
    var body: some View {
        VStack(spacing: 0) {
            
            List {
                
                Section {
                    
                    Text(reactor.state.post?.title ?? "")
                        .font(.title2)
                    
                    Text(reactor.state.post?.body ?? "")
                        
                }
                .listRowSeparator(.hidden)
                
                Section(header:
                    
                            Text("\(commentCount) comments:")
                    .bold()
                        
                ) {
                
                    ForEach(reactor.state.comments.item ?? [], id: \.id) { comment in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(comment.body)
                            Text("by \(comment.email.lowercased())")
                                .font(.caption)
                                .italic()
                        }
                        .padding(.vertical)
                    }
                }
            }                .listStyle(.plain)
            
            StateBarView(state: reactor.state.comments,
                         onTap: { Task { await reactor.action(.loadComments) }})
            
        }
        .onAppear {
            Task {
                await reactor.action(.loadComments)
            }
        }
        .refreshable {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                Task {
                    await reactor.action(.loadComments)
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
