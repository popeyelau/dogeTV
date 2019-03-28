//
//  EpisodeItemComponent.swift
//  dogeTV
//
//  Created by Popeye Lau on 2019/3/15.
//  Copyright © 2019 Popeye Lau. All rights reserved.
//

import UIKit
import SnapKit
import Carbon

import SwiftTheme

struct EpisodeItemComponent: IdentifiableComponent {
    typealias Content = UILabel

    var id: String {
        return data.url
    }

    var data: Episode

    func renderContent() -> Content {
        let content = Content()
        content.font = UIFont.systemFont(ofSize: 12)
        content.textAlignment = .center
        content.layer.cornerRadius = 6
        content.layer.masksToBounds = true
        return content
    }

    func render(in content: Content) {
        content.text = data.title
        content.theme_textColor = ["#434343", "#FFF"]
        content.theme_backgroundColor =  ["#F1F7F8", "#1E3141"]
    }

    func referenceSize(in bounds: CGRect) -> CGSize? {
        let inset: CGFloat = 20
        return CGSize(width: (bounds.size.width - inset - 15) / 4.0, height: 35)
    }

    func shouldContentUpdate(with next: EpisodeItemComponent) -> Bool {
        return data != next.data
    }
}

struct SourceItemComponent: IdentifiableComponent {
    typealias Content = UILabel
    
    var id: VideoSource {
        return data
    }
    
    var data: VideoSource


    func renderContent() -> Content {
        let content = Content()
        content.font = UIFont.systemFont(ofSize: 12)
        content.textAlignment = .center
        content.layer.cornerRadius = 6
        content.layer.masksToBounds = true
        return content
    }
    
    func render(in content: UILabel) {
        let title = data.source == 0 ? "默认线路" : "线路\(data.source)"
        content.text = title

        let textColor: ThemeColorPicker = data.isSelected ? ["#FFF", "#FFF"] :  ["#434343", "#FFF"]
        content.theme_textColor = textColor


        let backgroundColor: ThemeColorPicker = data.isSelected ? ["#434343", "#1E3141"] :  ["#F1F7F8", "#0D181F"]
        content.theme_backgroundColor = backgroundColor
    }
    
    func referenceSize(in bounds: CGRect) -> CGSize? {
        let column: CGFloat = 5.0
        let gap = (column - 1) * 5.0
        let inset: CGFloat = 20
        return CGSize(width: (bounds.size.width - inset - gap) / column, height: 35)
    }
    
    func shouldContentUpdate(with next: SourceItemComponent) -> Bool {
        return data != next.data
    }
}
