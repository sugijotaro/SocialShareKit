//
//  InstagramSharer.swift
//  SocialShareKit
//
//  Created by Jotaro Sugiyama on 2025/07/14.
//

import UIKit

public actor InstagramSharer {
    public static let shared = InstagramSharer()
    private let facebookAppId: String?
    
    public init(facebookAppId: String? = nil) {
        self.facebookAppId = facebookAppId
    }
    
    enum OptionKeys: String {
        case stickerImage = "com.instagram.sharedSticker.stickerImage"
        case backgroundImage = "com.instagram.sharedSticker.backgroundImage"
        case backgroundVideo = "com.instagram.sharedSticker.backgroundVideo"
        case backgroundTopColor = "com.instagram.sharedSticker.backgroundTopColor"
        case backgroundBottomColor = "com.instagram.sharedSticker.backgroundBottomColor"
        case contentURL = "com.instagram.sharedSticker.contentURL"
    }
    
    /// ステッカー画像をInstagram Storiesにシェアします。
    /// - Parameters:
    ///   - stickerImage: シェアするステッカー画像。
    ///   - topColor: 背景のグラデーション上部の色 (16進数文字列)。
    ///   - bottomColor: 背景のグラデーション下部の色 (16進数文字列)。
    ///   - contentURL: コンテンツURL（オプション）。
    public func share(stickerImage: UIImage, topColor: String = "#FFFFFF", bottomColor: String = "#FFFFFF", contentURL: String? = nil) async {
        
        guard let imageData = stickerImage.pngData() else {
            print("Failed to convert image to PNG data.")
            return
        }
        
        var items: [String: Any] = [
            OptionKeys.stickerImage.rawValue: imageData,
            OptionKeys.backgroundTopColor.rawValue: topColor,
            OptionKeys.backgroundBottomColor.rawValue: bottomColor
        ]
        
        if let contentURL = contentURL {
            items[OptionKeys.contentURL.rawValue] = contentURL
        }
        
        let pasteboardItems: [[String: Any]] = [items]
        
        let pasteboardOptions: [UIPasteboard.OptionsKey: Any] = [
            .expirationDate: Date().addingTimeInterval(60 * 5)
        ]
        
        let urlString = if let facebookAppId = facebookAppId {
            "instagram-stories://share?source_application=\(facebookAppId)"
        } else {
            "instagram-stories://share"
        }
        print("urlString: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("Failed to create Instagram Stories URL")
            return
        }
        
        await MainActor.run {
            UIPasteboard.general.setItems(pasteboardItems, options: pasteboardOptions)
            UIApplication.shared.open(url)
        }
    }
    
    /// 背景画像を使用してInstagram Storiesにシェアします。
    /// - Parameters:
    ///   - backgroundImage: 背景画像。
    ///   - stickerImage: ステッカー画像（オプション）。
    ///   - contentURL: コンテンツURL（オプション）。
    public func share(backgroundImage: UIImage, stickerImage: UIImage? = nil, contentURL: String? = nil) async {
        guard let bgData = backgroundImage.pngData() else {
            print("Failed to convert background image to PNG data.")
            return
        }
        
        var items: [String: Any] = [
            OptionKeys.backgroundImage.rawValue: bgData
        ]
        
        if let stickerImage = stickerImage,
           let stickerData = stickerImage.pngData() {
            items[OptionKeys.stickerImage.rawValue] = stickerData
        }
        
        if let contentURL = contentURL {
            items[OptionKeys.contentURL.rawValue] = contentURL
        }
        
        let pasteboardItems: [[String: Any]] = [items]
        let pasteboardOptions: [UIPasteboard.OptionsKey: Any] = [
            .expirationDate: Date().addingTimeInterval(60 * 5)
        ]
        
        let urlString = if let facebookAppId = facebookAppId {
            "instagram-stories://share?source_application=\(facebookAppId)"
        } else {
            "instagram-stories://share"
        }
        
        guard let url = URL(string: urlString) else {
            print("Failed to create Instagram Stories URL")
            return
        }
        
        await MainActor.run {
            UIPasteboard.general.setItems(pasteboardItems, options: pasteboardOptions)
            UIApplication.shared.open(url)
        }
    }
    
    /// 背景動画を使用してInstagram Storiesにシェアします。
    /// - Parameters:
    ///   - backgroundVideoURL: 背景動画のURL。
    ///   - stickerImage: ステッカー画像（オプション）。
    ///   - contentURL: コンテンツURL（オプション）。
    public func share(backgroundVideoURL: URL, stickerImage: UIImage? = nil, contentURL: String? = nil) async {
        let videoData: Data
        do {
            videoData = try Data(contentsOf: backgroundVideoURL)
        } catch {
            print("Cannot open video at \(backgroundVideoURL): \(error)")
            return
        }
        
        var items: [String: Any] = [
            OptionKeys.backgroundVideo.rawValue: videoData
        ]
        
        if let stickerImage = stickerImage,
           let stickerData = stickerImage.pngData() {
            items[OptionKeys.stickerImage.rawValue] = stickerData
        }
        
        if let contentURL = contentURL {
            items[OptionKeys.contentURL.rawValue] = contentURL
        }
        
        let pasteboardItems: [[String: Any]] = [items]
        let pasteboardOptions: [UIPasteboard.OptionsKey: Any] = [
            .expirationDate: Date().addingTimeInterval(60 * 5)
        ]
        
        let urlString = if let facebookAppId = facebookAppId {
            "instagram-stories://share?source_application=\(facebookAppId)"
        } else {
            "instagram-stories://share"
        }
        
        guard let url = URL(string: urlString) else {
            print("Failed to create Instagram Stories URL")
            return
        }
        
        await MainActor.run {
            UIPasteboard.general.setItems(pasteboardItems, options: pasteboardOptions)
            UIApplication.shared.open(url)
        }
    }
}
