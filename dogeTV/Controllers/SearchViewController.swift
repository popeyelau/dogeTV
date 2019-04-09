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

class SearchViewController: BaseViewController {
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search..."
        searchBar.delegate = self
        searchBar.theme_tintColor = AppColor.tintColor
        searchBar.removeBackgroundImageView()
        searchBar.theme_keyboardAppearance = AppColor.keyboardAppearance
        return searchBar
    }()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.theme_backgroundColor = AppColor.backgroundColor
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
    
    lazy var emptySection: Section = {
        return Section(id: "empty", header: ViewNode(EmptyComponent(text: "💌 How to use?\n\n 1. 搜索电影/演员/导演 \n\n2. 云解析 腾讯/优酷/爱奇艺/芒果TV 等会员视频")))
    }()

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
        render()
    }

    func setupViews() {
        view.addSubview(searchBar)
        view.theme_backgroundColor = AppColor.secondaryBackgroundColor
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            $0.left.equalToSuperview().offset(8)
            $0.right.equalToSuperview().offset(-8)
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
        if results.isEmpty {
            renderer.render(emptySection)
            return
        }
        
        let cells = results.map { (item) -> CellNode in
            CellNode(SearchItemComponent(data: item))
        }
        renderer.render(Section(id: 0, cells: cells))
    }
    
    func play(url: String) {
        guard !url.isEmpty, var streamURL = URL(string: url) else { return }
        
        if let querys = streamURL.queryParameters,
            let source = querys["url"],
            let decode = source.removingPercentEncoding {
            streamURL = URL(string: decode)!
        }
        
        self.showSuccess("解析成功, 即将跳转播放") { _ in
            let target = PlayerViewController()
            self.present(target, animated: true) {
                target.play(url: streamURL.absoluteString, title: nil)
            }
            self.searchBar.text = nil
        }
    }
}

extension URL {
    public var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.keywords = searchBar.text
        guard let keywords = keywords, keywords.count > 0 else { return }
        if keywords.lowercased().hasPrefix("http") {
            parse(url: keywords)
        } else {
            search(keywords: keywords)
        }
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
    
    func parse(url: String) {
        HUD.show(.progress)
        _ = APIClient.cloudParse(url: url)
            .done { (result) in
                guard !result.url.isEmpty else { return }
                self.play(url: result.url)
            }.catch({ (error) in
                print(error)
                self.showError(error)
            }).finally {
                HUD.hide()
        }
    }
    
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



