//
//  SearchViewController.swift
//  dogeTV
//
//  Created by Popeye Lau on 2019/3/14.
//  Copyright © 2019 Popeye Lau. All rights reserved.
//

import UIKit
import SnapKit
import Carbon
import PromiseKit
import Kingfisher
import PKHUD

class SearchViewController: UIViewController {
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "请输入影片名称"
        searchBar.delegate = self
        return searchBar
    }()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.groupTableViewBackground
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()


    var index: Int = 1
    var results: [Video] = []
    var keywords: String?

    lazy var renderer = Renderer(
        target: collectionView,
        adapter: UICollectionViewFlowLayoutAdapter(),
        updater: UICollectionViewUpdater()
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "搜索"
        setupViews()

        collectionView.bindFootRefreshHandler({ [weak self] in
            self?.loadMore()
            }, themeColor: .darkGray, refreshStyle: .replicatorWoody)
        collectionView.footRefreshControl.autoRefreshOnFoot = true
        
        if searchBar.canBecomeFirstResponder {
            searchBar.becomeFirstResponder()
        }
    }
    
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(44)
        }
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        renderer.adapter.didSelect = {[weak self] ctx in
            guard let item = ctx.node.component.as(SearchItemComponent.self) else {
                return
            }
            self?.showVideo(with: item.id)
        }
    }


    func render() {
        let cells = results.map { (item) -> CellNode in
            CellNode(SearchItemComponent(data: item))
        }
        renderer.render(Section(id: 0, cells: cells))
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.keywords = searchBar.text
        guard let keywords = keywords, keywords.count > 0 else { return }
        search(keywords: keywords)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }

}

extension SearchViewController {
    func search(keywords: String) {

        HUD.show(.progress)
        _ = APIClient.search(keywords: keywords)
            .done { (items) in
                self.results = items
            }.catch({ (error) in
                print(error)
                self.showError(error)
            }).finally {
                self.index = 1
                self.collectionView.footRefreshControl.resumeRefreshAvailable()
                HUD.hide()
                self.render()
        }
    }

    func loadMore() {
        guard let keywords = keywords else {
            return
        }
        index += 1
        APIClient.search(keywords: keywords, page: index).done { (videos) in
            if videos.isEmpty {
                self.collectionView.footRefreshControl.endRefreshingAndNoLongerRefreshing(withAlertText: "已经全部加载完毕")
                return
            }
            self.results.append(contentsOf: videos)
            }.catch{ (error) in
                self.index = max(1, self.index-1)
                self.showError(error)
            }.finally {
                self.render()
                self.collectionView.footRefreshControl.endRefreshing()
        }
    }
}



