//
//  SocialShareService.swift
//  SocialShareKit
//
//  Created by Jotaro Sugiyama on 2025/07/14.
//

import SwiftUI
import PhotosUI

public actor SocialShareService {
    public static let shared = SocialShareService()
    private let instagramSharer = InstagramSharer()
    
    private init() {}
    
    public func shareToX(content: ShareContent) async {
        let image = content.image(for: .x)
        let textForX = content.text(for: .x) ?? ""
        let hashtags = content.xHashtags?.map { "#" + $0 }.joined(separator: " ") ?? ""
        let fullText = "\(textForX) \(hashtags)".trimmingCharacters(in: .whitespacesAndNewlines)
        let encodedText = fullText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        guard let url = URL(string: "twitter://post?text=\(encodedText)") else { return }
        
        await MainActor.run {
            UIPasteboard.general.image = image
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                let webURLString = "https://twitter.com/intent/tweet?text=\(encodedText)"
                if let webURL = URL(string: webURLString) {
                    UIApplication.shared.open(webURL)
                }
            }
        }
    }
    
    public func shareToInstagramStory(content: ShareContent) async {
        let image = content.image(for: .instagramStory)
        await instagramSharer.share(stickerImage: image)
    }
    
    public func shareToLINE(content: ShareContent) async {
        let image = content.image(for: .line)
        let pastBoard: UIPasteboard = UIPasteboard.general
        pastBoard.setData(image.jpegData(compressionQuality: 1.0)!, forPasteboardType: "public.png")
        let shareURLString: String = String(format: "line://msg/image/%@", pastBoard.name as CVarArg)
        guard let url = URL(string: shareURLString) else {
            print("Failed to create LINE share URL")
            return
        }
        await MainActor.run {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                print("Failed to open LINE share URL")
            }
        }
    }
    
    public func shareToSystem(content: ShareContent) async {
        let image = content.image(for: .more)
        let text = content.text(for: .more) ?? ""
        
        let items: [Any] = [image, text].filter { ($0 is String) ? !($0 as! String).isEmpty : true }
        
        let activityVC = await UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        await MainActor.run {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootViewController = windowScene.windows.first?.rootViewController else { return }
            
            if let popoverController = activityVC.popoverPresentationController {
                popoverController.sourceView = rootViewController.view
                popoverController.sourceRect = CGRect(x: rootViewController.view.bounds.midX, y: rootViewController.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            
            rootViewController.present(activityVC, animated: true, completion: nil)
        }
    }
}
