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

class TopicViewController: BaseViewController {
    var topicId: String?
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.minimumInteritemSpacing = 0
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
    var videos: [Video] = []
    var topic: Topic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        refresh()
        collectionView.headRefreshControl.beginRefreshing()
    }
    
    func setupViews() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        collectionView.bindHeadRefreshHandler({ [weak self] in
            self?.refresh()
            }, themeColor: .darkGray, refreshStyle: .replicatorWoody)
        
        renderer.target = collectionView
        renderer.adapter.didSelect = { [weak self] context in
            guard let item = context.node.component.as(VideoItemComponent.self) else{
                return
            }
            self?.showVideo(with: item.data.id)
        }
    }

    
    func render() {
        var header: ViewNode?
        if let topic = topic {
            header = ViewNode(TopicHeaderComponent(data: topic))
        }
        let cells = videos.map {
            CellNode(VideoItemComponent(data: $0))
        }
        renderer.render(Section(id: 0, header: header, cells: cells))
    }
}

extension TopicViewController {
    func refresh() {
        guard let topicId = topicId else {
            return
        }
        fetchTopic(id: topicId)
    }

    func fetchTopic(id: String) {
        APIClient.fetchTopic(id: id).done { (topicInfo) in
            self.title = topicInfo.topic.title
            self.videos = topicInfo.items
            self.topic = topicInfo.topic
            }.catch{ (error) in
                self.showError(error)
            }.finally {
                self.render()
                self.collectionView.headRefreshControl.endRefreshing()
        }
    }
}




