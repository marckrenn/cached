//
//  ReactorView.swift
//  cached
//
//  Created by Marc Krenn on 04.10.22.
//

import SwiftUI
import AsyncReactor

public struct ReactorView<Content: View, R: AsyncReactor>: View {
    let content: Content
    
    @StateObject
    private var reactor: R
    
    public init(_ reactor: @escaping @autoclosure () -> R, @ViewBuilder content: () -> Content) {
        _reactor = StateObject(wrappedValue: reactor())
        self.content = content()
    }
    
    public var body: some View {
        content
            .environmentObject(reactor)
    }
}
