//
//  VideoHeaderComponent.swift
//  dogeTV
//
//  Created by Popeye Lau on 2019/3/15.
//  Copyright © 2019 Popeye Lau. All rights reserved.
//

import UIKit
import SnapKit
import Carbon


struct VideoHeaderComponent: IdentifiableComponent {
    typealias Content = VideoHeaderContentView

    var id: String {
        return data.id
    }

    var data: Video

    func renderContent() -> Content {
        let content = Content()
        return content
    }

    func render(in content: Content) {
        content.coverImageView.setResourceImage(with: data.cover)
        content.titleLabel.text = data.name
        content.introLabel.text = "导演: \(data.director)\n主演: \(data.actor)\n国家/地区: \(data.area)\n上映: \(data.year )\n类型: \(data.tag)\n\(data.state)"
    }

    func referenceSize(in bounds: CGRect) -> CGSize? {
        return CGSize(width: bounds.width, height: bounds.height * 0.25)
    }

    func shouldContentUpdate(with next: VideoHeaderComponent) -> Bool {
        return data != next.data
    }
}



class VideoHeaderContentView: UIView {
    lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = false
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        imageView.layer.shadowOpacity = 0.24
        imageView.layer.shadowRadius = CGFloat(2.0)
        return imageView
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.theme_textColor = AppColor.textColor
        label.font = .preferredFont(forTextStyle: .callout)
        return label
    }()

    lazy var introLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.theme_textColor = AppColor.textColor
        label.numberOfLines = 10
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(coverImageView)
        addSubview(titleLabel)
        addSubview(introLabel)

        let padding = 8.0

        coverImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.left.equalToSuperview().offset(padding)
            $0.width.equalTo(coverImageView.snp.height).dividedBy(1.35)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(coverImageView)
            $0.left.equalTo(coverImageView.snp.right).offset(padding)
            $0.right.equalToSuperview().offset((-padding))
        }
        introLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(padding)
            $0.right.equalToSuperview().offset((-padding))
            $0.left.equalTo(titleLabel)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
