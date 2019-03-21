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

class LiveViewController: UIViewController, SegementSlideContentScrollViewDelegate {
    var location: TV = .iptv

    var scrollView: UIScrollView {
        return collectionView
    }

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    lazy var renderer = Renderer(
        target: collectionView,
        adapter: UICollectionViewFlowLayoutAdapter(),
        updater: UICollectionViewUpdater()
    )

    var index: Int = 1
    var channels: [Channel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        refresh()
    }


    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        renderer.adapter.didSelect = { [weak self] ctx in
            guard let item = ctx.node.component.as(ChannelItemComponent.self) else{
                return
            }

            UIPasteboard.general.string = item.data.url
            let target = PlayerViewController()
            self?.present(target, animated: true) {
                target.play(url: item.data.url, title: nil)
            }
        }
    }

    func render() {
        let cells = channels.map { (item) -> CellNode in
            CellNode(ChannelItemComponent(data: item))
        }
        let footer = ViewNode(ChannelFooterComponent(data: "网友分享"))
        renderer.render(Section(id: 0, cells: cells, footer: footer))
    }
}

extension LiveViewController {
    func refresh() {
        HUD.show(.progress)
            _ = APIClient.fetchTV(location).done { (channels) in
                self.channels = channels.sorted(by: { $0.name < $1.name })
                }.catch({ (error) in
                    self.showError(error)
                }).finally {
                    HUD.hide()
                    self.render()
            }
    }
}

