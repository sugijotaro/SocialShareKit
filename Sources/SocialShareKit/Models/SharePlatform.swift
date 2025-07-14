//
//  SharePlatform.swift
//  SocialShareKit
//
//  Created by Jotaro Sugiyama on 2025/07/14.
//

import SwiftUI

public enum SharePlatform: Identifiable, CaseIterable, Sendable {
    case x
    case instagramStory
    case line
    case more
    
    public var id: Self { self }
    
    @ViewBuilder
    public var icon: some View {
        switch self {
        case .x:
            Image("x_icon")
                .resizable()
        case .instagramStory:
            Image("instagram_icon")
                .resizable()
        case .line:
            Image("line_icon")
                .resizable()
        case .more:
            Image(systemName: "ellipsis")
                .foregroundColor(.white)
        }
    }
}
