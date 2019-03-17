//
//  RankItemComponent.swift
//  dogeTV
//
//  Created by Popeye Lau on 2019/3/16.
//  Copyright © 2019 Popeye Lau. All rights reserved.
//

import UIKit
import SnapKit
import Carbon


struct RankItemComponent: IdentifiableComponent {
    typealias Content = RankItemContentView

    var id: String {
        return data.id
    }

    let data: Ranking

    func renderContent() -> Content {
        let content = Content()
        return content
    }

    func render(in content: Content) {
        content.titleLabel.text = data.name
        content.hotLabel.text = data.hot
        content.indexLabel.text = data.index
        if let index = Int(data.index) {
            content.indexLabel.backgroundColor = index < 4 ? .darkGray : UIColor(hexString: "#DDDDDD")
            content.indexLabel.textColor = index < 4 ? .white : .black
        }
    }

    func referenceSize(in bounds: CGRect) -> CGSize? {
        return CGSize(width: bounds.width, height: 60)
    }

    func shouldContentUpdate(with next: RankItemComponent) -> Bool {
        return data.id != next.data.id
    }
}

class RankItemContentView: UIView {

    lazy var indexLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 3
        label.layer.masksToBounds = true
        return label
    }()

    lazy var hotLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#d04341")
        label.font = .systemFont(ofSize: 12)
        return label
    }()


    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello World"
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .darkGray
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    func setupViews() {
        backgroundColor = .white
        clipsToBounds = true
        addSubview(titleLabel)
        addSubview(indexLabel)
        addSubview(hotLabel)

        indexLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.size.equalTo(30)
        }

        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(indexLabel.snp.right).offset(8)
        }
        hotLabel.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-8)
            $0.centerY.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
