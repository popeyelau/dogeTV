//
//  VideoItemComponent.swift
//  dogeTV
//
//  Created by Popeye Lau on 2019/3/15.
//  Copyright © 2019 Popeye Lau. All rights reserved.
//

import UIKit
import SnapKit
import Carbon


struct VideoItemComponent: IdentifiableComponent {
    typealias Content = VideoItemContentView

    var id: String {
        return data.id
    }

    let data: Video

    func renderContent() -> VideoItemContentView {
        let content = VideoItemContentView()
        return content
    }

    func render(in content: VideoItemContentView) {
        content.coverImageView.setResourceImage(with: data.cover)
        content.titleLabel.text = data.name
        let update = data.state
        content.updateLabel.text = " \(update) "
        content.updateLabel.isHidden = update.isEmpty
        content.shadowImageView.isHidden = update.isEmpty
    }

    func referenceSize(in bounds: CGRect) -> CGSize? {
        let length = ceil(bounds.width * 0.3)
        return CGSize(width: length, height: length * 1.65)
    }

    func shouldContentUpdate(with next: VideoItemComponent) -> Bool {
        return data.id != next.data.id
    }
}

class VideoItemContentView: UIView {
    lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        return imageView
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textAlignment = .center
        label.textColor = .darkGray
        return label
    }()
    
    lazy var updateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .white
        return label
    }()

    lazy var shadowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "shadow")
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    func setupViews() {
        backgroundColor = .white
        clipsToBounds = true
        addSubview(coverImageView)
        addSubview(titleLabel)
        coverImageView.snp.makeConstraints {
            $0.top.centerX.left.equalToSuperview()
            $0.height.equalTo(coverImageView.snp.width).multipliedBy(1.4)
            $0.bottom.equalTo(titleLabel.snp.top).offset(-8)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(coverImageView.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(8)
            $0.centerX.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview().offset(-8)
        }

        coverImageView.addSubview(shadowImageView)
        shadowImageView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        addSubview(updateLabel)
        updateLabel.snp.makeConstraints {
            $0.left.equalTo(coverImageView).offset(5)
            $0.bottom.equalTo(coverImageView).offset(-5)
            $0.right.equalTo(coverImageView).offset(-5)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
