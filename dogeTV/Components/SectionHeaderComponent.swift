//
//  SectionHeaderComponent.swift
//  dogeTV
//
//  Created by Popeye Lau on 2019/3/15.
//  Copyright © 2019 Popeye Lau. All rights reserved.
//

import UIKit
import SnapKit
import Carbon

struct SectionHeaderComponent: Component {
    typealias Content = SectionHeaderContentView

    typealias Callback = ((Category?) -> Void)
    let title: String
    let category: Category?
    var onArrowSelected: Callback?

    init(title: String, category: Category? = nil, onArrowSelected: Callback? = nil) {
        self.title = title
        self.category = category
        self.onArrowSelected = onArrowSelected
    }

    func renderContent() -> Content {
        let content = Content()
        content.onArrowSelected = onArrowSelected
        return content
    }

    func render(in content: Content) {
        content.titleLabel.text = title
        content.category = category
        content.onArrowSelected = onArrowSelected
    }

    func referenceSize(in bounds: CGRect) -> CGSize? {
        return CGSize(width: bounds.width, height: 44)
    }

    func shouldContentUpdate(with next: SectionHeaderComponent) -> Bool {
        return title != next.title
    }
}

class SectionHeaderContentView: UIView {
    typealias Callback = ((Category?) -> Void)

    var onArrowSelected: Callback?
    var category: Category?

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        return label
    }()

    lazy var moreBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = .systemFont(ofSize: 13)
        btn.setTitleColor(.darkGray, for: .normal)
        btn.titleLabel?.textAlignment = .right
        btn.setTitle("更多 >", for: .normal)
        btn.addTarget(self, action: #selector(more), for: .touchUpInside)
        return btn
    }()

    lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(titleLabel)
        addSubview(moreBtn)
        addSubview(indicatorView)

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
        moreBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
            $0.width.greaterThanOrEqualTo(50)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func more() {
        onArrowSelected?(category)
    }
}
