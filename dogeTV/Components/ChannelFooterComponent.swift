//
//  ChannelFooterComponent.swift
//  dogeTV
//
//  Created by Popeye Lau on 2019/3/3.
//  Copyright © 2019 Popeye Lau. All rights reserved.
//

import UIKit
import SnapKit
import Carbon


struct ChannelFooterComponent: Component {
    typealias Content = UILabel
    
    var data: String

    func renderContent() -> Content {
        let content = Content()
        return content
    }

    func render(in content: Content) {
        content.text = data
        content.font = UIFont.preferredFont(forTextStyle: .caption1)
        content.textColor = .lightGray
        content.textAlignment = .center
    }

    func referenceSize(in bounds: CGRect) -> CGSize? {
        return CGSize(width: bounds.width , height: 40)
    }

    func shouldContentUpdate(with next: ChannelFooterComponent) -> Bool {
        return data != next.data
    }

}
