//
//  TopicsViewController.swift
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

class TopicsViewController: BaseViewController {
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
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
    var topics: [Topic] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
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
        renderer.adapter.didSelect = { [weak self] ctx in
            guard let item = ctx.node.component.as(TopicItemComponent.self) else {
                return
            }
            let target = TopicViewController()
            target.topicId = item.data.id
           self?.push(viewController: target, animated: true)
        }
    }

    func render() {
        let cells = topics.map { (item) -> CellNode in
            CellNode(TopicItemComponent(data: item))
        }
        renderer.render(Section(id: 0, cells: cells))
    }
}

extension TopicsViewController {
    func refresh() {
        _ = APIClient.fetchTopics().done { (topics) in
            self.topics = topics
            }.catch({ (error) in
                self.showError(error)
            }).finally {
                self.render()
                self.collectionView.headRefreshControl.endRefreshing()
        }
    }
}
