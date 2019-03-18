//
//  CategoryViewController.swift
//  dogeTV
//
//  Created by Popeye Lau on 2019/3/1.
//  Copyright © 2019 Popeye Lau. All rights reserved.
//

import UIKit
import PromiseKit
import SegementSlide


class CategoryViewController: SegementSlideViewController {

    enum CategoryViewSourceType {
        case rank
        case normal
        var title: String {
            switch self {
            case .rank: return "排行榜"
            case .normal: return "影视库"
            }
        }
    }

    var sourceType: CategoryViewSourceType = .normal

    override func viewDidLoad() {

        super.viewDidLoad()
        title = sourceType.title
        if sourceType == .normal {
            let rankBtn = UIBarButtonItem(image: UIImage(named: "ranking"), style: .plain, target: self, action: #selector(rank))
            navigationItem.rightBarButtonItem = rankBtn
        }
        refresh()
    }
    
    override var bouncesType: BouncesType {
        return .child
    }
    
    override var switcherConfig: SegementSlideSwitcherConfig {
        var config = SegementSlideSwitcherConfig.shared
        config.indicatorColor = .darkGray
        config.normalTitleColor = .gray
        config.selectedTitleColor = .darkGray
        config.type = .tab
        return config
    }
    override var titlesInSwitcher: [String] {
        return Category.allCases.map { $0.title }
    }

    override func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        switch sourceType {
        case .normal:
            let target = MediaListViewController()
            target.category = Category.allCases[index]
            return target
        case .rank:
            let target = RankListViewController()
            target.category = Category.allCases[index]
            return target
        }
    }

    @objc func rank() {
        let target = CategoryViewController()
        target.sourceType = .rank
        navigationController?.pushViewController(target, animated: true)
    }
}



extension CategoryViewController {
    func refresh() {
        self.reloadData()
        self.scrollToSlide(at: 0, animated: false)
    }
}
