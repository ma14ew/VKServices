//
//  WebView.swift
//  VK2023
//
//  Created by Матвей Матюшко on 19.02.2023.
//


import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    var services: AboutServicesModel?
    
    init(services: AboutServicesModel){
        self.services = services
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var webView: WKWebView = {
        let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: CGRect(x: 220, y: 220, width: 100, height: 100))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
       
        
        guard let url = URL(string: self.services!.service_url) else { return }
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        DispatchQueue.main.async {
            self.webView.load(URLRequest(url: url))
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else {return}
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    private func setupConstraints(){
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
}

