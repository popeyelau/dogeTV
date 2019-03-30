//
//  BaseViewController.swift
//  dogeTV
//
//  Created by Popeye Lau on 2019/3/28.
//  Copyright © 2019 Popeye Lau. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        view.theme_backgroundColor = AppColor.backgroundColor
    }
}

