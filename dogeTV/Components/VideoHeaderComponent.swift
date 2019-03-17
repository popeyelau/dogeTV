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
        content.backgroundImageView.setResourceImage(with: data.cover, placeholder: UIImage(named: "blur"))
        content.titleLabel.text = data.name
        content.introLabel.text = "导演: \(data.director)\n主演: \(data.actor)\n国家/地区: \(data.area)\n上映: \(data.year )\n类型: \(data.tag)\n\(data.state)"
    }

    func referenceSize(in bounds: CGRect) -> CGSize? {
        return CGSize(width: bounds.width, height: UIScreen.main.bounds.height * 0.3)
    }

    func shouldContentUpdate(with next: VideoHeaderComponent) -> Bool {
        return data != next.data
    }
}



class VideoHeaderContentView: UIView {
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .callout)
        return label
    }()

    lazy var introLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .groupTableViewBackground
        label.numberOfLines = 10
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backgroundImageView)
        addSubview(coverImageView)
        addSubview(titleLabel)
        addSubview(introLabel)

        let padding = 8.0

        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        coverImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(padding)
            $0.height.equalToSuperview().offset(-padding*2).multipliedBy(0.9)
            $0.width.equalTo(coverImageView.snp.height).dividedBy(1.5)
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
