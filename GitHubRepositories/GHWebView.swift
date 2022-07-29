//
//  GHWebView.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/29/22.
//

import SwiftUI
import WebKit

struct GHWebView: UIViewRepresentable {
    
    @Binding var isPresented: Bool
    var container: DIContainer
    let url: URLRequest
    
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.load(url)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        
        var parent: GHWebView
        
        
        init(_ parent: GHWebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            requestForCallbackURL(request: navigationAction.request)
            decisionHandler(.allow)
        }
        
        func requestForCallbackURL(request: URLRequest) {
            guard let requestURL = request.url, let authCode = requestURL.authCode else { return }
            
            parent.container.services.authService.authTokenRequest(with: authCode)
            parent.isPresented = false
        }
    }
}
