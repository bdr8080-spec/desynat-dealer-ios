//
//  SupportChatViewController.swift
//  DesynatDealer
//
//  Created by RakhiKumari on 13/04/26.
//

import UIKit
import WebKit

class SupportChatViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var contentWebview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupWebView()
        if let savedUser: User = kSharedUserDefaults.retrieveModelFor(key: .user, model: User.self) {
            loadTidioHTML(user: savedUser)
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupWebView() {
        contentWebview.navigationDelegate = self
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("WebView loaded")
        
        webView.evaluateJavaScript("document.body.innerHTML") { result, error in
            print("HTML:", result ?? "")
        }
    }
    
    func loadTidioHTML(user: User) {
        let name = (user.firstName ?? "").replacingOccurrences(of: "\"", with: "\\\"")
        let email = (user.email ?? "").replacingOccurrences(of: "\"", with: "\\\"")
        let userId = "\(user.id ?? 0)".replacingOccurrences(of: "\"", with: "\\\"")
        let phone = (user.mobile ?? "").replacingOccurrences(of: "\"", with: "\\\"")
        
        let html  = """
        <!DOCTYPE html>
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        
        
        <style>
        html, body {
            margin: 0;
            padding: 0;
            background-color: white;
        }
        
        iframe[src*="tidio"],
        #tidio-chat,
            .tidio-chat {
                display: none !important;
                opacity: 0 !important;
                visibility: hidden !important;
            }
        </style>
        
        <!-- ✅ IMPORTANT: Use full https URL -->
        <script src="https://code.tidio.co/na5y0weklpcd9uxhccfezplsfg0fggvk.js" async></script>
        </head>
        
        <body>
        
        <script>
        document.addEventListener("tidioChat-ready", function () {
            if (!window.tidioChatApi) return;
            
            // 👤 Set user data
            window.tidioChatApi.setVisitorData({
                name: "\(name)",
                email: "\(email)",
                distinct_id: "\(userId)",
                phone: "\(phone)"
            });
            
            // 🔥 Force open chat without showing button
            setTimeout(function () {
                
                // 👁 Show widget again (after hiding it initially)
                const style = document.createElement("style");
                style.innerHTML = `
                iframe[src*="tidio"],
                #tidio-chat,
                    .tidio-chat {
                        display: block !important;
                        opacity: 1 !important;
                        visibility: visible !important;
                    }
                `;
                document.head.appendChild(style);
                
                // 💬 Open chat directly
                window.tidioChatApi.show();
                window.tidioChatApi.open();
                
            }, 800); // small delay ensures proper load
        });
        </script>
        
        </body>
        </html>
        """
        
        
        contentWebview.loadHTMLString(html, baseURL: URL(string: "https://localhost"))
    }
}
