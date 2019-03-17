//
//  RankListViewController.swift
//  dogeTV
//
//  Created by Popeye Lau on 2019/3/16.
//  Copyright © 2019 Popeye Lau. All rights reserved.
//

import UIKit
import Carbon
import Kingfisher
import PromiseKit
import KafkaRefresh
import SegementSlide

class RankListViewController: UIViewController, SegementSlideContentScrollViewDelegate {

    var category: VideoCategory = .film

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.groupTableViewBackground
        return tableView
    }()

    lazy var renderer = Renderer(
        target: tableView,
        adapter: UITableViewAdapter(),
        updater: UITableViewUpdater()
    )

    var index: Int = 1
    var list: [Ranking] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        tableView.headRefreshControl.beginRefreshing()
    }


    var scrollView: UIScrollView {
        return tableView
    }

    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        tableView.bindHeadRefreshHandler({ [weak self] in
            self?.refresh()
            }, themeColor: .darkGray, refreshStyle: .replicatorWoody)

        renderer.adapter.didSelect = { [weak self] ctx in
            guard let self = self, let item = ctx.node.component.as(RankItemComponent.self) else {
                return
            }
            self.showMeida(id: item.data.id)
        }
    }

    func render() {
        let cells = list.map { (item) -> CellNode in
            CellNode(RankItemComponent(data: item))
        }
        renderer.render(
            Section(id: 0, cells: cells)
        )
    }
}

extension RankListViewController {
    func refresh() {
        attempt(maximumRetryCount: 3) {
            APIClient.fetchRankList(category: self.category)
            }.done { (list) in
                self.list = list
            }.catch({ (error) in
                self.showError(error)
            }).finally {
                self.render()
                self.tableView.headRefreshControl.endRefreshing()
        }
    }
}
