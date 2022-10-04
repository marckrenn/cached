//
//  cachedApp.swift
//  cached
//
//  Created by Marc Krenn on 29.09.22.
//

import SwiftUI
import AsyncReactor

@main
struct cachedApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ReactorView(ProfilesReactor()) { ProfilesListView() }
                    .navigationTitle("Users")
            }
        }
    }
}
