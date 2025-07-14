//
//  ShareContent.swift
//  SocialShareKit
//
//  Created by Jotaro Sugiyama on 2025/07/14.
//

import UIKit

public struct PlatformSpecificContent: Sendable {
    public var image: UIImage?
    public var text: String?
    
    public init(image: UIImage? = nil, text: String? = nil) {
        self.image = image
        self.text = text
    }
}

public struct ShareContent: Sendable {
    public var image: UIImage
    public var text: String?
    public var xHashtags: [String]?
    public var platformSpecific: [SharePlatform: PlatformSpecificContent]?
    
    public init(
        image: UIImage,
        text: String? = nil,
        xHashtags: [String]? = nil,
        platformSpecific: [SharePlatform: PlatformSpecificContent]? = nil
    ) {
        self.image = image
        self.text = text
        self.xHashtags = xHashtags
        self.platformSpecific = platformSpecific
    }
    
    func image(for platform: SharePlatform) -> UIImage {
        return platformSpecific?[platform]?.image ?? self.image
    }
    
    func text(for platform: SharePlatform) -> String? {
        return platformSpecific?[platform]?.text ?? self.text
    }
}
