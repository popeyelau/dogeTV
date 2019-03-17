//
//  SearchItemComponent.swift
//  dogeTV
//
//  Created by Popeye Lau on 2019/3/15.
//  Copyright © 2019 Popeye Lau. All rights reserved.
//

import UIKit
import SnapKit
import Carbon

struct SearchItemComponent: IdentifiableComponent {
    typealias Content = SearchItemContentView

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
        content.introLabel.text = "国家/地区: \(data.area) \(data.year)\n类型: \(data.tag)\n主演: \(data.actor)"
    }

    func referenceSize(in bounds: CGRect) -> CGSize? {
        return CGSize(width: bounds.width - 16, height: 120)
    }

    func shouldContentUpdate(with next: SearchItemComponent) -> Bool {
        return data.id != next.data.id
    }
}



class SearchItemContentView: UIView {

    lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello World"
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    lazy var introLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello WorldHello WorldHello WorldHello WorldHello WorldHello WorldHello World"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        label.numberOfLines = 4
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        //layer.cornerRadius = 6
        backgroundColor = .white
        addSubview(coverImageView)
        addSubview(titleLabel)
        addSubview(introLabel)

        let padding = 8.0

        coverImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(padding)
            $0.height.equalToSuperview().multipliedBy(0.9)
            $0.width.equalTo(coverImageView.snp.height).dividedBy(1.2)
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

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        superview?.layer.shadowColor = UIColor.black.cgColor
        superview?.layer.shadowOpacity = 0.1
        superview?.layer.shadowRadius = 6
        superview?.layer.shadowOffset = CGSize(width: 0, height: 1)
    }
}
