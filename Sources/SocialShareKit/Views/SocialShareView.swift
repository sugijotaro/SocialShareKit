//
//  SocialShareView.swift
//  SocialShareKit
//
//  Created by Jotaro Sugiyama on 2025/07/14.
//

import SwiftUI

public struct SocialShareView: View {
    let platforms: [SharePlatform]
    let content: ShareContent
    let iconSize: CGFloat
    
    @State private var resultMessage: String?
    @State private var isShowingMessage = false
    
    public init(platforms: [SharePlatform], content: ShareContent, iconSize: CGFloat = 48) {
        self.platforms = platforms
        self.content = content
        self.iconSize = iconSize
    }
    
    public var body: some View {
        HStack(spacing: 24) {
            ForEach(platforms) { platform in
                Button(action: {
                    handleShare(for: platform)
                }) {
                    platform.icon
                        .frame(width: iconSize, height: iconSize)
                        .background(
                            platform == .more ? Color.white.opacity(0.2) : Color.clear
                        )
                        .clipShape(Circle())
                }
            }
        }
    }
    
    private func handleShare(for platform: SharePlatform) {
        let service = SocialShareService.shared
        Task {
            switch platform {
            case .x:
                await service.shareToX(content: content)
            case .instagramStory:
                await service.shareToInstagramStory(content: content)
            case .line:
                await service.shareToLINE(content: content)
            case .more:
                await service.shareToSystem(content: content)
            }
        }
    }
}
