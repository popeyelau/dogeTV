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
import SPStorkController

class MediaListViewController: UIViewController, SegementSlideContentScrollViewDelegate {
    
    var category: Category!
    var query: [OptionSet]?
    lazy var queryPanel: QueryOptionsController = {
        let queryPanel = QueryOptionsController()
        queryPanel.modalPresentationCapturesStatusBarAppearance = true
        return queryPanel
    }()
    
    lazy var floatingBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .darkGray
        btn.setImage(UIImage(named: "filter"), for: .normal)
        btn.addTarget(self, action: #selector(showQueryPanel), for: .touchUpInside)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 20
        btn.alpha = 0.85
        return btn
    }()
    
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
    var selectedKeys: [String:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        collectionView.headRefreshControl.beginRefreshing()
    }
    
  
    
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(floatingBtn)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        floatingBtn.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-16)
            $0.size.equalTo(40)
        }
        collectionView.bindFootRefreshHandler({ [weak self] in
            self?.loadMore()
            }, themeColor: .darkGray, refreshStyle: .replicatorWoody)
        collectionView.footRefreshControl.autoRefreshOnFoot = true
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
        renderer.render(Section(id: 1, cells: cells)) { [weak self] in
            guard let queryPanel = self?.presentedViewController else {
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                SPStorkController.updatePresentingController(modal: queryPanel)
            })
        }
    }
    
    @objc func showQueryPanel() {
        queryPanel.query = query
        queryPanel.onSelectOptions = { [weak self] in
            self?.refresh()
        }
        let height = UIScreen.main.bounds.height * 0.75
        presentAsStork(queryPanel, height: height, showIndicator: true, complection: nil)
    }
    
    var selectedQuery: String {
        let tag = query?.first { $0.title == OptionSetType.tag.rawValue }?.options.first { $0.isSelected }?.key ?? ""
        var otherKeys = query?.filter { $0.title != OptionSetType.tag.rawValue }.flatMap { $0.options }.filter { $0.isSelected }.map { $0.key }.joined(separator: "-") ?? ""
        if otherKeys.hasPrefix("-") {
           otherKeys.removeFirst()
        }
        if otherKeys.hasSuffix("-") {
            otherKeys.removeLast()
        }
        otherKeys = otherKeys.count > 0 ? "-\(otherKeys)" : ""
        if tag.count > 0 {
            return "/\(tag)\(otherKeys)"
        }
        return otherKeys
    }
}

extension MediaListViewController {
    func refresh() {
        guard let category = self.category else {
            return
        }
        attempt(maximumRetryCount: 3) {
            APIClient.fetchCategoryList(category: category, query: self.selectedQuery)}
            .done { (category) in
                if self.query == nil {
                    self.query = category.query
                }
                self.videos = category.items
            }.catch({ (error) in
                self.showError(error)
            }).finally {
                self.index = 1
                self.render()
                self.collectionView.headRefreshControl.endRefreshing()
                self.collectionView.footRefreshControl.resumeRefreshAvailable()
        }
    }
    
    func loadMore() {
        index += 1
        APIClient.fetchCategoryList(category: category, page: index, query: selectedQuery).done { category in
            if category.items.isEmpty {
                self.collectionView.footRefreshControl.endRefreshingAndNoLongerRefreshing(withAlertText: "已经全部加载完毕")
                return
            }
            self.videos.append(contentsOf: category.items)
            }.catch{ (err) in
                self.index = max(1, self.index-1)
                self.showError(err)
            }.finally {
                self.render()
                self.collectionView.footRefreshControl.endRefreshing()
        }
    }
}




