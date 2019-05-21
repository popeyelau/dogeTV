//
//  LivesViewController.swift
//  dogeTV
//
//  Created by Popeye Lau on 2019/3/3.
//  Copyright © 2019 Popeye Lau. All rights reserved.
//

import UIKit
import PromiseKit
import SegementSlide

class LivesViewController: SegementSlideViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "电视直播"
        view.theme_backgroundColor = AppColor.backgroundColor
        slideContentView.theme_backgroundColor =  AppColor.backgroundColor
        /*
        let moreBarBtn = UIBarButtonItem(image: UIImage(named: "web"), style: .plain, target: self, action: #selector(more(_:)))
        navigationItem.rightBarButtonItems = [moreBarBtn]*/
        slideSwitcherView.theme_backgroundColor = AppColor.slideSwitcherColor
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(themeDidUpdated),
            name: NSNotification.Name(rawValue: "ThemeUpdateNotification"),
            object: nil
        )
        refresh()
    }
    
    var categories: [IPTV] = [] {
        didSet {
            reloadData()
            scrollToSlide(at: 0, animated: false)
        }
    }

    @objc func themeDidUpdated() {
        reloadSwitcher()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override var bouncesType: BouncesType {
        return .child
    }

    override var switcherConfig: SegementSlideSwitcherConfig {
        var config = SegementSlideSwitcherConfig.shared
        config.indicatorColor = AppTheme.isDark ? .groupTableViewBackground : .darkGray
        config.normalTitleColor = .lightGray
        config.selectedTitleColor = AppTheme.isDark ? .groupTableViewBackground : .darkGray
        config.type = .segement
        return config
    }
    
    
    override var titlesInSwitcher: [String] {
        return categories.map { $0.category }
    }

    @objc func more(_ sender: UIBarButtonItem) {
        let target = WebViewController()
        push(viewController: target, animated: true)
    }

    override func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        let categoryId = categories[index].id
        let target = LiveViewController()
        target.categoryId = categoryId
        return target
    }
}

extension LivesViewController {
    func refresh() {
        _ = APIClient.fetchIPTVCategories().done { (categories) in
            self.categories = categories
            }.catch({ (error) in
                self.showError(error)
            }).finally {
        }
    }
}
