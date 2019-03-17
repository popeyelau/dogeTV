//
//  MediaListViewController.swift
//  dogeTV
//
//  Created by Popeye Lau on 2019/3/1.
//  Copyright © 2019 Popeye Lau. All rights reserved.
//

import UIKit
import Carbon
import Kingfisher
import PromiseKit
import KafkaRefresh
import SegementSlide

class MediaListViewController: UIViewController, SegementSlideContentScrollViewDelegate {
    
    var category: VideoCategory!
    
    var scrollView: UIScrollView {
        return self.collectionView
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.minimumInteritemSpacing = 0
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
    var videos: [Video] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        collectionView.headRefreshControl.beginRefreshing()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        collectionView.bindFootRefreshHandler({ [weak self] in
            self?.loadMore()
            }, themeColor: .darkGray, refreshStyle: .replicatorWoody)
        
        collectionView.bindHeadRefreshHandler({ [weak self] in
            self?.refresh()
            }, themeColor: .darkGray, refreshStyle: .replicatorWoody)
        
        renderer.adapter.didSelect = { [weak self] ctx in
            guard let self = self, let item = ctx.node.component.as(VideoItemComponent.self) else {
                return
            }
            self.showMeida(id: item.data.id)
        }
    }
    
    func render() {
        let cells = videos.map { (item) -> CellNode in
            CellNode(VideoItemComponent(data: item))
        }
        renderer.render(
            Section(id: 1, cells: cells)
        )
    }
}

extension MediaListViewController {
    func refresh() {
        guard let category = self.category else {
            return
        }
        attempt(maximumRetryCount: 3) {
            APIClient.fetchCategoryList(category: category)
            }.done { (videos) in
            self.videos = videos
            }.catch({ (error) in
                self.showError(error)
            }).finally {
                self.render()
                self.collectionView.headRefreshControl.endRefreshing()
                self.collectionView.footRefreshControl.resumeRefreshAvailable()
        }
    }
    
    func loadMore() {
        index += 1
        APIClient.fetchDoubanList(category: category, page: index).done { videos in
                self.videos.append(contentsOf: videos)
            }.catch{ (err) in
                self.index = max(1, self.index-1)
                self.showError(err)
            }.finally {
                self.render()
                self.collectionView.footRefreshControl.endRefreshing()
        }
    }
}

