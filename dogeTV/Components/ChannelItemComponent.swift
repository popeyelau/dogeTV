//
//  ChannelItemComponent.swift
//  dogeTV
//
//  Created by Popeye Lau on 2019/3/3.
//  Copyright © 2019 Popeye Lau. All rights reserved.
//

import UIKit
import SnapKit
import Carbon


struct ChannelItemComponent: IdentifiableComponent {
    typealias Content = ChannelItemContentView

    var id: String {
        return data.url
    }

    var data: IPTVChannel

    func renderContent() -> Content {
        let content = Content()
        return content
    }

    func render(in content: Content) {
        content.titleLabel.text = data.name
    }

    func referenceSize(in bounds: CGRect) -> CGSize? {
        return CGSize(width: (bounds.width - 16)  / 3.0 - 5 , height: 80)
    }

    func shouldContentUpdate(with next: ChannelItemComponent) -> Bool {
        return data.url != next.data.url
    }

}



class ChannelItemContentView: UIView {

    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "tv")
        imageView.theme_tintColor = AppColor.secondaryTextColor
        return imageView
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        label.theme_textColor = AppColor.secondaryTextColor
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        layer.cornerRadius = 6
        addSubview(titleLabel)
        addSubview(iconImageView)
        
        layer.theme_borderColor = AppColor.borderColor
        layer.borderWidth = 0.5

        iconImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(8)
            $0.height.equalToSuperview().multipliedBy(0.5)
        }
        titleLabel.snp.makeConstraints {
            $0.centerX.equalTo(snp.centerX)
            $0.top.equalTo(iconImageView.snp.bottom).offset(2)
            $0.left.equalToSuperview().offset(4)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
