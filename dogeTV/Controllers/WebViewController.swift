//
//  WebViewController.swift
//  dogeTV
//
//  Created by Popeye Lau on 2019/3/2.
//  Copyright © 2019 Popeye Lau. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

class WebViewController: UIViewController {
    lazy var webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "电视节目"
        view.addSubview(webView)
        webView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        let request = URLRequest(url: URL(string: "http://wx.iptv186.com/?act=home")!)
        webView.load(request)
    }
}
