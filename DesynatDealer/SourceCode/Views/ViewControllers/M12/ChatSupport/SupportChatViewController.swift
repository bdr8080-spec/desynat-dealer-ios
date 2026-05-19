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
        CommonUtils.showHud(show: true)
        setupWebView()
        
        if let savedUser: User = kSharedUserDefaults.retrieveModelFor(key: .user, model: User.self) {
            loadTidioHTML(user: savedUser)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            CommonUtils.showHud(show: false)
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
        
        // Language setup
        let isArabic = AppLanguageManager.shared.currentLanguage == .ar
        let langCode = isArabic ? "ar" : "en"
        
        let html = """
        <!DOCTYPE html>
        <html lang="\(langCode)">
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            
            <style>
            html, body {
                margin: 0;
                padding: 0;
                background-color: white;
                direction: \(isArabic ? "rtl" : "ltr");
                text-align: \(isArabic ? "right" : "left");
            }
            
            /* Hide initially */
            iframe[src*="tidio"], #tidio-chat, .tidio-chat {
                display: none !important;
            }
            </style>
            
            <script>
                // Set language as early as possible
                window.tidioChatLang = "\(langCode)";
                document.documentElement.lang = "\(langCode)";
                
                // Extra hint for Tidio
                window.__tidioLang = "\(langCode)";
            </script>
            
            <script src="https://code.tidio.co/uxltmye9ysuvgaamvz0sisfhvdb1yctx.js" async></script>
        </head>

        <body>
        <script>
            document.addEventListener("tidioChat-ready", function () {
                if (!window.tidioChatApi) return;
                
                window.tidioChatApi.setVisitorData({
                    name: "\(name)",
                    email: "\(email)",
                    distinct_id: "\(userId)",
                    phone: "\(phone)"
                });
                
                // Force language again after ready
                if (window.tidioChatApi.setLanguage) {
                    window.tidioChatApi.setLanguage("\(langCode)");
                }
                
                setTimeout(function () {
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
                    
                    window.tidioChatApi.show();
                    window.tidioChatApi.open();
                }, 1200);
            });
        </script>
        </body>
        </html>
        """
        
        contentWebview.loadHTMLString(html, baseURL: URL(string: "https://localhost"))
    }
}
