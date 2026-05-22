//
//  TextShareSource.swift
//  DesynatDealer
//
//  Created by fluper_mac2 on 19/05/26.
//


import UIKit
import UniformTypeIdentifiers
import LinkPresentation

// MARK: - Helper (Decode safely) - MOVED TO TOP LEVEL
func fullyDecoded(_ text: String) -> String {
    let once = text.removingPercentEncoding ?? text
    let twice = once.removingPercentEncoding ?? once
    return twice
}

// MARK: - Text Share Source (FIXED with NSItemProvider)
final class TextShareSource: NSObject, UIActivityItemSource {
    
    private let text: String
    
    init(text: String) {
        self.text = fullyDecoded(text)
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return ""
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController,
                                itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        
        let itemProvider = NSItemProvider()
        itemProvider.registerDataRepresentation(forTypeIdentifier: UTType.plainText.identifier, visibility: .all) { completion in
            let data = self.text.data(using: .utf8)!
            completion(data, nil)
            return nil
        }
        
        // Also register as string for broader compatibility
        itemProvider.registerObject(self.text as NSItemProviderWriting, visibility: .all)
        
        return itemProvider
    }
}

// MARK: - Image Share Source (unchanged)
final class ImageShareSource: NSObject, UIActivityItemSource {
    
    private let image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return image
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController,
                                itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return image
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.imageProvider = NSItemProvider(object: image)
        return metadata
    }
}

// MARK: - Share Utility (COMPLETE)
final class ShareUtility {
    
    static func shareProduct(
        image: UIImage? = nil,
        imageURL: String? = nil,
        title: String,
        description: String,
        link: String,
        from viewController: UIViewController
    ) {
        // ✅ Decode everything FIRST
        let cleanTitle = fullyDecoded(title)
        let cleanDescription = fullyDecoded(description)
        let cleanLink = fullyDecoded(link)
        
        let shareText = "\(cleanTitle)\n\n\(cleanDescription)\n\n\(cleanLink)"
        //        print("DEBUG SHARE TEXT:\n\(shareText)") // Debug
        
        if let image = image {
            presentShare(image: image, text: shareText, from: viewController)
        }
        else if let imageURL = imageURL,
                let url = URL(string: fullyDecoded(imageURL)) {
            
            URLSession.shared.dataTask(with: url) { data, _, _ in
                DispatchQueue.main.async {
                    if let data = data,
                       let downloadedImage = UIImage(data: data) {
                        presentShare(image: downloadedImage, text: shareText, from: viewController)
                    } else {
                        presentShare(image: nil, text: shareText, from: viewController)
                    }
                }
            }.resume()
        } else {
            presentShare(image: nil, text: shareText, from: viewController)
        }
    }
    
    private static func presentShare(
        image: UIImage?,
        text: String,
        from viewController: UIViewController
    ) {
        var activityItems: [Any] = [TextShareSource(text: text)]
        
        if let image = image {
            activityItems.append(ImageShareSource(image: image))
        }
        
        let activityVC = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        
        // iPad support
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = viewController.view
            popover.sourceRect = viewController.view.bounds
            popover.permittedArrowDirections = []
        }
        
        if let lifeCycleVC = viewController as? ActivityHolding {
            lifeCycleVC.currentActivityVC = activityVC
        }
        
        viewController.present(activityVC, animated: true)
    }
}

// MARK: - Protocol (unchanged)
protocol ActivityHolding: AnyObject {
    var currentActivityVC: UIActivityViewController? { get set }
}


