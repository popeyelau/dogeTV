//
//  VideoEpisodeHeaderComponent.swift
//  dogeTV
//
//  Created by Popeye Lau on 2019/3/17.
//  Copyright © 2019 Popeye Lau. All rights reserved.
//

import UIKit
import SnapKit
import Carbon

struct VideoEpisodeHeaderComponent: Component {
    typealias Content = VideoEpisodeHeaderContentView

    var data: String
    var subTitle: String?
    
    init(title: String, subTitle: String? = nil) {
        self.data = title
        self.subTitle = subTitle
    }

    func renderContent() -> Content {
        let content = Content()
        return content
    }

    func render(in content: Content) {
        content.titleLabel.text = data
        content.subTitleLabel.text = subTitle
    }

    func referenceSize(in bounds: CGRect) -> CGSize? {
        return CGSize(width: bounds.size.width, height: 40)
    }

    func shouldContentUpdate(with next: VideoEpisodeHeaderComponent) -> Bool {
        return data != next.data
    }
}

class VideoEpisodeHeaderContentView: UIView {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.theme_textColor = AppColor.textColor
        return label
    }()
    
    lazy var indicatorView: UIView = {
        let view = UIView()
        view.theme_backgroundColor = AppColor.indicatorColor
        return view
    }()

    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.theme_textColor = AppColor.secondaryTextColor
        label.textAlignment = .right
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(indicatorView)
        addSubview(titleLabel)
        addSubview(subTitleLabel)

        indicatorView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.35)
            $0.width.equalTo(2)
            $0.left.equalToSuperview().offset(8)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(indicatorView.snp.right).offset(8)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-8)
            $0.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(8)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
