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

class LiveViewController: BaseViewController, SegementSlideContentScrollViewDelegate {
    var location: TV = .iptv

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
        target: collectionView,
        adapter: UICollectionViewFlowLayoutAdapter(),
        updater: UICollectionViewUpdater()
    )

    var index: Int = 1
    var groups: [ChannelGroup] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let toggleBarBtn = UIBarButtonItem(image: UIImage(named: "toggle"), style: .plain, target: self, action: #selector(toggle(_:)))
        navigationItem.rightBarButtonItem = toggleBarBtn
        setupViews()
        updateTitle()
        refresh()
    }
    
    @objc func toggle(_ sender: UIBarButtonItem) {
        location = location.next()
        refresh()
    }
    
    func updateTitle() {
       title = location.title
    }

    func setupViews() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        renderer.adapter.didSelect = { [weak self] ctx in
            guard let item = ctx.node.component.as(ChannelItemComponent.self) else{
                return
            }
            self?.player(with: item.data.url)
        }
    }

    func render() {
        let sections = groups.map { (category) -> Section in
            let cells = category.channels.map { CellNode(ChannelItemComponent(data: $0)) }
            let header = groups.count > 1  ? ViewNode(VideoEpisodeHeaderComponent(title: category.categoryName))  : nil
            let section = Section(id: category.categoryName, header: header, cells: cells)
            return section
        }
        renderer.render(sections)
    }
}

extension LiveViewController {
    func refresh() {
        HUD.show(.progress)
            _ = APIClient.fetchTV(location).done { (groups) in
                self.groups = groups
                self.updateTitle()
                }.catch({ (error) in
                    self.showError(error)
                }).finally {
                    HUD.hide()
                    self.render()
                    self.collectionView.setContentOffset(.zero, animated: true)
            }
    }
}

