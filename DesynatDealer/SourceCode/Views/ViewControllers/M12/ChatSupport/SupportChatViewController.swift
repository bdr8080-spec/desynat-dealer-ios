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
        loadChat()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupWebView() {
//        contentWebview = WKWebView()
        contentWebview.navigationDelegate = self
//        contentWebview.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(webView)
//        
//        NSLayoutConstraint.activate([
//            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
//        ])
    }
    
    func loadChat() {
        if let filePath = Bundle.main.path(forResource: "Chat", ofType: "html") {
            let url = URL(fileURLWithPath: filePath)
            contentWebview.loadFileURL(url, allowingReadAccessTo: url)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("WebView loaded")
        
        webView.evaluateJavaScript("document.body.innerHTML") { result, error in
            print("HTML:", result ?? "")
        }
    }
    
}
