//
//  UIImageViewExtension.swift
//  dogeTV
//
//  Created by Popeye Lau on 2019/3/16.
//  Copyright © 2019 Popeye Lau. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setResourceImage(with url: String, placeholder: UIImage? = UIImage(named: "404")) {
        self.kf.setImage(with: URL(string: "\(ENV.resourceHost)\(url)"),
                         placeholder: placeholder,
                         options: [.transition(.fade(1))])
    }
}
