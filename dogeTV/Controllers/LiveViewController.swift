//
//  LiveViewController.swift
//  dogeTV
//
//  Created by Popeye Lau on 2019/3/2.
//  Copyright © 2019 Popeye Lau. All rights reserved.
//

import UIKit
import Carbon
import Kingfisher
import PromiseKit
import SegementSlide
import PKHUD

let userAgent = ["User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36"]

class LiveViewController: BaseViewController, SegementSlideContentScrollViewDelegate {
    var categoryId: String?
    
    var scrollView: UIScrollView {
        return collectionView
    }

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.theme_backgroundColor = AppColor.backgroundColor
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    lazy var renderer = Renderer(
        adapter: UICollectionViewFlowLayoutAdapter(),
        updater: UICollectionViewUpdater()
    )

    var index: Int = 1
    var channels: [IPTVChannel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        refresh()
    }
    
    func setupViews() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        renderer.target = collectionView
        renderer.adapter.didSelect = { [weak self] ctx in
            guard let item = ctx.node.component.as(ChannelItemComponent.self) else{
                return
            }
            self?.getStreamURL(channel: item.data)
        }
    }

    func render() {
        let cells = channels.map { CellNode(ChannelItemComponent(data: $0)) }
        let section = Section(id: 0, cells: cells)
        renderer.render(section)
    }
}

extension LiveViewController {
    func refresh() {
        guard let tid = categoryId else {
            return
        }
        HUD.show(.progress)
            _ = APIClient.fetchIPTV(tid: tid).done { (channels) in
                self.channels = channels
                }.catch({ (error) in
                    self.showError(error)
                }).finally {
                    HUD.hide()
                    self.render()
                    self.collectionView.setContentOffset(.zero, animated: true)
            }
    }
    
    func getStreamURL(channel: IPTVChannel) {
        guard let channelURL = URL(string: channel.url) else {
            return
        }
        
        HUD.show(.progress)
        getHTMLBody(from: channelURL)
            .map { ($0, "<option+.*?</option>") }
            .then(extractURL)
            .then(getHTMLBody)
            .map { ($0, "url: '(.*?)'") }
            .then(extractURL)
            .done({ (url) in
                self.play(with: url.absoluteString)
            }).catch { (err) in
                print(err)
            }.finally {
                HUD.hide()
        }
    }
    
    func extractURL(from body: String, regex: String) -> Promise<URL> {
        return Promise<URL> { resolver in
            guard let url = self.firstMatch(for: regex, in: body)?.extractURLs().first else{
                resolver.reject(E.decodeFaild)
                return
            }
            resolver.fulfill(url)
        }
    }
    
    func getHTMLBody(from url: URL) -> Promise<String> {
        return AlamofireManager.shared.request(url, method: .get, headers: userAgent)
            .responseString()
            .map { $0.string }
    }
    
    func firstMatch(for regex: String, in text: String) -> String? {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            guard let result = regex.firstMatch(in: text,
                                                range: NSRange(text.startIndex..., in: text)) else {
                                                    return nil
            }
            return String(text[Range(result.range, in: text)!])
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return nil
        }
    }
}

