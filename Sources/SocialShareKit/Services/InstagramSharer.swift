//
//  InstagramSharer.swift
//  SocialShareKit
//
//  Created by Jotaro Sugiyama on 2025/07/14.
//

import UIKit

public actor InstagramSharer {
    private let urlScheme = URL(string: "instagram-stories://share")!
    
    enum OptionKeys: String {
        case stickerImage = "com.instagram.sharedSticker.stickerImage"
        case backgroundTopColor = "com.instagram.sharedSticker.backgroundTopColor"
        case backgroundBottomColor = "com.instagram.sharedSticker.backgroundBottomColor"
    }
    
    /// ステッカー画像をInstagram Storiesにシェアします。
    /// - Parameters:
    ///   - stickerImage: シェアするステッカー画像。
    ///   - topColor: 背景のグラデーション上部の色 (16進数文字列)。
    ///   - bottomColor: 背景のグラデーション下部の色 (16進数文字列)。
    public func share(stickerImage: UIImage, topColor: String = "#FFFFFF", bottomColor: String = "#FFFFFF") async {
        
        guard let imageData = stickerImage.pngData() else {
            print("Failed to convert image to PNG data.")
            return
        }
        
        let pasteboardItems: [[String: Any]] = [
            [
                OptionKeys.stickerImage.rawValue: imageData,
                OptionKeys.backgroundTopColor.rawValue: topColor,
                OptionKeys.backgroundBottomColor.rawValue: bottomColor
            ]
        ]
        
        let pasteboardOptions: [UIPasteboard.OptionsKey: Any] = [
            .expirationDate: Date().addingTimeInterval(60 * 5)
        ]
        
        await MainActor.run {
            UIPasteboard.general.setItems(pasteboardItems, options: pasteboardOptions)
            UIApplication.shared.open(urlScheme)
        }
    }
}
