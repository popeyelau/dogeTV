//
//  SettingsViewController.swift
//  dogeTV
//
//  Created by Popeye Lau on 2019/4/11.
//  Copyright © 2019 Popeye Lau. All rights reserved.
//

import UIKit
import Carbon
import SPStorkController

class SettingsViewController: BaseViewController {

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.tableFooterView = UIView()
        tableView.theme_backgroundColor = AppColor.secondaryBackgroundColor
        tableView.theme_separatorColor = AppColor.separatorColor
        return tableView
    }()
    
    lazy var renderer = Renderer(
        target: tableView,
        adapter: SettingsTableViewAdapter(),
        updater: UITableViewUpdater()
    )
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "设置"
        setupViews()
        render()
    }
    
    
    var scrollView: UIScrollView {
        return tableView
    }
    
    func setupViews() {
        view.theme_backgroundColor = AppColor.secondaryBackgroundColor
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0))
        }
    }
    
    func render() {
        
        var cells = [
            CellNode(FormSwitchComponent(title: "夜间模式", isOn: AppTheme.isDark, onSwitch: { (isOn) in
                self.updateTheme()
            })),
        ]
        if UIApplication.shared.canOpenURL(URL(string: "nplayer-http://")!) {
            let nplayerCell = CellNode(FormSwitchComponent(title: "使用 nPlayer 播放", isOn: ENV.usingnPlayer, onSwitch: { (isOn) in
                ENV.usingnPlayer = isOn
            }))
            cells.append(nplayerCell)
        }
        renderer.render(Section(id: "preference", cells: cells))
    }
    
    func updateTheme() {
        AppTheme.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            SPStorkController.updatePresentingController(modal: self)
        }
    }
}

class SettingsTableViewAdapter: UITableViewAdapter {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        SPStorkController.scrollViewDidScroll(scrollView)
    }
}
