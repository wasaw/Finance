//
//  WebViewController.swift
//  Finance
//
//  Created by Александр Меренков on 25.10.2023.
//

import Foundation
import WebKit

final class WebKitController: UIViewController {
    
// MARK: - Properties
    
    private let url: URL
    private lazy var webView = WKWebView()
    
// MARK: - Lifecycle
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = webView
        DispatchQueue.main.async {
            self.webView.load(URLRequest(url: self.url))
        }
        webView.allowsBackForwardNavigationGestures = true
    }
}
