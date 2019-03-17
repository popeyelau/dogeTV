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
    var onSwitch: () -> Void

    func renderContent() -> Content {
        let content = Content()
        return content
    }

    func render(in content: Content) {
        content.episodeBtn.setTitle(" [ \(data) ]", for: .normal)
        content.onSwitch = onSwitch
    }

    func referenceSize(in bounds: CGRect) -> CGSize? {
        return CGSize(width: bounds.size.width, height: 40)
    }

    func shouldContentUpdate(with next: VideoEpisodeHeaderComponent) -> Bool {
        return data != next.data
    }
}

class VideoEpisodeHeaderContentView: UIView {

    var onSwitch: (() -> Void)?
    lazy var episodeBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .black
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setImage(UIImage(named: "line"), for: .normal)
        button.setTitle("切换路线", for: .normal)
        button.addTarget(self, action: #selector(switchBtnTaped), for: .touchUpInside)
        return button
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        label.text = "(☚ 点击切换线路, 线路画质从高到低)"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(titleLabel)
        addSubview(episodeBtn)

        episodeBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(8)
        }
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(episodeBtn.snp.right).offset(8)
            $0.right.lessThanOrEqualTo(self).offset(-8)
        }

    }

    @objc func switchBtnTaped() {
        onSwitch?()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
