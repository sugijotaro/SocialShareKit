//
//  ContentView.swift
//  SocialShareKitDemoApp
//
//  Created by Jotaro Sugiyama on 2025/07/14.
//

import SwiftUI
import SocialShareKit

struct ContentView: View {
    var body: some View {
        VStack {
            SocialShareView(
                platforms: [.instagramStory, .x, .line, .more],
                content: ShareContent(
                    image: UIImage(systemName: "globe")!,
                    text: "Hello, World!",
                    xHashtags: ["SocialShareKit", "SwiftUI"]
                )
            )
            .padding()
            .background(.gray)
        }
    }
}

#Preview {
    ContentView()
}
