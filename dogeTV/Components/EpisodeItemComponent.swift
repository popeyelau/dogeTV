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
        content.layer.borderWidth = 0.5
        content.theme_textColor = ["#434343", "#FFF"]
        content.layer.theme_borderColor = ["#BFBFBF", "#203040"]
        content.backgroundColor = .clear
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

        content.layer.borderWidth = data.isSelected ? 0.0 : 0.5
        content.layer.theme_borderColor = ["#BFBFBF", "#203040"]

        let backgroundColor: ThemeColorPicker = data.isSelected ? ["#434343", "#1E3141"] :  ["#4c000000", "#4c000000"]
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
