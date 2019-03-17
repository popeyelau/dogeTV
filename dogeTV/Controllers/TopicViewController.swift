//
//  TopicViewController.swift
//  dogeTV
//
//  Created by Popeye Lau on 2019/3/14.
//  Copyright © 2019 Popeye Lau. All rights reserved.
//

import UIKit
import Carbon
import Kingfisher
import PromiseKit
import KafkaRefresh

class TopicViewController: UIViewController {
    enum TopicViewSourceType {
        case topic(id: String)
        case category(category: VideoCategory)
    }

    var sourceType: TopicViewSourceType = .category(category: .film)
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
        refresh()
        collectionView.headRefreshControl.beginRefreshing()
    }
    
    func setupViews() {
        view.backgroundColor = UIColor.groupTableViewBackground
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        collectionView.bindHeadRefreshHandler({ [weak self] in
            self?.refresh()
            }, themeColor: .darkGray, refreshStyle: .replicatorWoody)


        if case let TopicViewSourceType.category(category) = sourceType {
            title = category.title
            collectionView.bindFootRefreshHandler({ [weak self] in
                self?.loadMore()
                }, themeColor: .darkGray, refreshStyle: .replicatorWoody)
        }

        renderer.adapter.didSelect = { [weak self] context in
            guard let item = context.node.component.as(VideoItemComponent.self) else{
                return
            }
            self?.showMeida(id: item.data.id)
        }
    }

    
    func render() {
        let cells = videos.map {
            CellNode(VideoItemComponent(data: $0))
        }
        renderer.render(Section(id: 0, cells: cells))
    }
}

extension TopicViewController {
    func refresh() {
        switch sourceType {
        case .topic(let id):
            return fetchTopic(id: id)
        case .category(let category):
            return fetchVideosInCategory(of: category)
        }
    }

    func fetchTopic(id: String) {
        APIClient.fetchTopic(id: id).done { (topicInfo) in
            self.title = topicInfo.topic.title
            self.videos = topicInfo.items
            }.catch{ (error) in
                self.showError(error)
            }.finally {
                self.render()
                self.collectionView.headRefreshControl.endRefreshing()
        }
    }

    func loadMore() {
        guard case let TopicViewSourceType.category(category) = sourceType else {
            return
        }
        index += 1
        APIClient.fetchDoubanList(category: category, page: index).done { (videos) in
             self.videos.append(contentsOf: videos)
            }.catch{ (error) in
                self.index = max(1, self.index-1)
                self.showError(error)
            }.finally {
                self.render()
                self.collectionView.footRefreshControl.endRefreshing()
        }
    }

    func fetchVideosInCategory(of category: VideoCategory) {
        APIClient.fetchDoubanList(category: category, page: 1).done { (videos) in
            self.videos = videos
            }.catch{ (error) in
                self.showError(error)
            }.finally {
                self.render()
                self.collectionView.headRefreshControl.endRefreshing()
        }
    }
}




