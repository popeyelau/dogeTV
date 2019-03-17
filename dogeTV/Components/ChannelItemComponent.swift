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

    var data: Channel

    func renderContent() -> Content {
        let content = Content()
        return content
    }

    func render(in content: Content) {
        content.titleLabel.text = data.name.replacingOccurrences(of: "频道超高清", with: "", options: .literal, range: nil).uppercased()
        if data.icon.isEmpty {
            content.backgroundImageView.image = nil
            content.backgroundImageView.backgroundColor = .gray
            content.iconImageView.image = UIImage(named: "tv_logo")
        } else {
            content.backgroundImageView.kf.setImage(with: URL(string: data.icon))
            content.iconImageView.kf.setImage(with: URL(string: data.icon), options: [.transition(.fade(1))])
        }
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
        return imageView
    }()

    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image =  UIImage(named: "tv_bg")
        return imageView
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "PingFangSC-medium", size: 14)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        layer.cornerRadius = 6
        addSubview(backgroundImageView)
        addSubview(titleLabel)
        addSubview(iconImageView)

        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
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

        let blur = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: blur)
        backgroundImageView.addSubview(effectView)
        effectView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
