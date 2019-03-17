//
//  TopicHeaderComponent.swift
//  dogeTV
//
//  Created by Popeye Lau on 2019/3/3.
//  Copyright © 2019 Popeye Lau. All rights reserved.
//


import UIKit
import SnapKit
import Carbon


struct TopicHeaderComponent: IdentifiableComponent {
    typealias Content = TopicHeaderContentView

    var id: String {
        return data.id
    }

    var data: Topic

    func renderContent() -> Content {
        let content = Content()
        return content
    }

    func render(in content: Content) {
        content.backgroundImageView.setResourceImage(with: data.cover, placeholder: UIImage(named: "blur"))
        content.titleLabel.text = data.title
        content.introLabel.text = data.desc
    }

    func referenceSize(in bounds: CGRect) -> CGSize? {
        return CGSize(width: bounds.width, height: 200)
    }

    func shouldContentUpdate(with next: TopicHeaderComponent) -> Bool {
        return data != next.data
    }
}



class TopicHeaderContentView: UIView {
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
        imageView.layer.cornerRadius = 40
        return imageView
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    lazy var introLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption2)
        label.textColor = .groupTableViewBackground
        label.numberOfLines = 10
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backgroundImageView)
        addSubview(titleLabel)
        addSubview(introLabel)

        let padding = 8.0

        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(padding)
            $0.top.equalToSuperview().offset(padding)
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
