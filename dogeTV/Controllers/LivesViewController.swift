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
        let moreBarBtn = UIBarButtonItem(image: UIImage(named: "web"), style: .plain, target: self, action: #selector(more(_:)))
        navigationItem.rightBarButtonItems = [moreBarBtn]
        slideSwitcherView.theme_backgroundColor = AppColor.backgroundColor
        reloadData()
        scrollToSlide(at: 0, animated: false)
    }

    override var bouncesType: BouncesType {
        return .child
    }

    override var switcherConfig: SegementSlideSwitcherConfig {
        var config = SegementSlideSwitcherConfig.shared
        config.indicatorColor = AppTheme.isDark ? .white : .darkGray
        config.normalTitleColor = .lightGray
        config.selectedTitleColor = AppTheme.isDark ? .white : .darkGray
        config.type = .tab
        return config
    }
    
    
    override var titlesInSwitcher: [String] {
        return TV.allCases.map { $0.title }
    }

    @objc func more(_ sender: UIBarButtonItem) {
        let target = WebViewController()
        navigationController?.pushViewController(target, animated: true)
    }

    override func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        let target = LiveViewController()
        target.location = TV(rawValue: index)!
        return target
    }
}


