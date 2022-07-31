//
//  GHWebView.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/29/22.
//

import SwiftUI
import WebKit
import UniformTypeIdentifiers

struct GRWebView: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    
    var container: DIContainer
    let request: URLRequest
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let vc = WebviewController()
        vc.title = request.url?.host ?? ""
        vc.delegate = context.coordinator
        vc.webview.navigationDelegate = context.coordinator
        
        if container.appState.hasNetwork {
            vc.webview.load(request)
        } else {
            loadSavedPage(in: vc.webview)
        }
        
        return UINavigationController(rootViewController: vc)
    }
    
    private func loadSavedPage(in webView: WKWebView) {
        guard let url = request.url,
              let data = container.services.persistenceClient.loadWebData(with: String(describing: url)),
              let mimeType = UTType.webArchive.preferredMIMEType else {
            return
        }
        
        webView.load(data, mimeType: mimeType, characterEncodingName: "utf-8", baseURL: url)
    }
    
    func makeCoordinator() -> Coordinator {
        let offlineMode = !container.appState.hasNetwork
        return Coordinator(self, offLineMode: offlineMode)
    }
    
    final class Coordinator: NSObject, WKNavigationDelegate, WebViewVCDelegate {
        
        let parent: GRWebView
        private var pageSaved = false
        
        init(_ parent: GRWebView, offLineMode: Bool = false) {
            self.parent = parent
            pageSaved = offLineMode
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            requestForCallbackURL(request: navigationAction.request)
            decisionHandler(.allow)
        }
        
        func requestForCallbackURL(request: URLRequest) {
            guard let requestURL = request.url, let authCode = requestURL.authCode else { return }
            
            parent.container.services.authService.authTokenRequest(with: authCode)
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            guard !pageSaved else { return }
            
            webView.createWebArchiveData { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    self.parent.container.services.persistenceClient.saveWebData(data, from: self.parent.request.url)
                    self.pageSaved = true
                    
                case .failure(let error):
                    self.parent.container.appState.alert(body: error.localizedDescription)
                }
            }
        }
        
        func doneTapped() {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) { }
}



fileprivate class WebviewController: UIViewController, WKNavigationDelegate {
    
    lazy var webview: WKWebView = WKWebView()
    lazy var progressbar: UIProgressView = UIProgressView()
    
    var delegate: WebViewVCDelegate?

    deinit {
        webview.removeObserver(self, forKeyPath: "estimatedProgress")
        webview.scrollView.removeObserver(self, forKeyPath: "contentOffset")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadTapped))

        view.addSubview(webview)

        webview.frame = view.frame
        webview.scrollView.bounces = true
        webview.scrollView.alwaysBounceVertical = true

        webview.addSubview(progressbar)
        setProgressBarPosition()

        webview.scrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)

        progressbar.progress = 0.1
        webview.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }

    func setProgressBarPosition() {
        progressbar.translatesAutoresizingMaskIntoConstraints = false
        webview.removeConstraints(webview.constraints)
        webview.addConstraints([
            progressbar.topAnchor.constraint(equalTo: webview.topAnchor, constant: webview.scrollView.contentOffset.y * -1),
            progressbar.leadingAnchor.constraint(equalTo: webview.leadingAnchor),
            progressbar.trailingAnchor.constraint(equalTo: webview.trailingAnchor),
        ])
    }

    // MARK: - Web view progress
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case "estimatedProgress":
            if webview.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, animations: { [weak self] () in
                    self?.progressbar.alpha = 0.0
                }, completion: { [weak self] finished in
                    self?.progressbar.setProgress(0.0, animated: false)
                })
            } else {
                progressbar.isHidden = false
                progressbar.alpha = 1.0
                progressbar.setProgress(Float(webview.estimatedProgress), animated: true)
            }

        case "contentOffset":
            setProgressBarPosition()

        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    @objc private func doneTapped() {
        delegate?.doneTapped()
    }
    
    @objc private func reloadTapped() {
        webview.reload()
    }
}

protocol WebViewVCDelegate {
    func doneTapped()
}
