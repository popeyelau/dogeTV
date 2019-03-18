//
//  QueryItemComponent.swift
//  dogeTV
//
//  Created by Popeye Lau on 2019/3/18.
//  Copyright © 2019 Popeye Lau. All rights reserved.
//

import UIKit
import SnapKit
import Carbon


struct QueryItemComponent: IdentifiableComponent {
    typealias Content = QueryItemContentView
    
    var id: String {
        return data.key
    }
    
    let data: Option
    let set: String
    
    func renderContent() -> Content {
        let content = Content()
        return content
    }
    
    func render(in content: Content) {
        content.titleLabel.text = data.text
        if data.isSelected {
            content.titleLabel.backgroundColor = .gray
            content.titleLabel.textColor = .white
        } else {
            content.titleLabel.backgroundColor = .groupTableViewBackground
            content.titleLabel.textColor = .darkGray
        }
    }
    
    func referenceSize(in bounds: CGRect) -> CGSize? {
        let width = data.text.widthOfString(usingFont: .systemFont(ofSize: 12)) + 10
        return CGSize(width: width, height: 30)
    }
    
    func shouldContentUpdate(with next: QueryItemComponent) -> Bool {
        return true
    }
}

class QueryItemContentView: UIView {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .darkGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        backgroundColor = UIColor.groupTableViewBackground
        clipsToBounds = true
        layer.cornerRadius = 3
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



struct QuerySetHeaderComponent: Component {
    typealias Content = UILabel
    
    let data: String

    func renderContent() -> Content {
        let content = Content()
        return content
    }

    func render(in content: Content) {
        content.text = data
        content.font = .systemFont(ofSize: 14)
        content.textColor = .darkGray
        content.textAlignment = .center
    }
    
    func referenceSize(in bounds: CGRect) -> CGSize? {
        return CGSize(width: bounds.width , height: 30)
    }
    
    func shouldContentUpdate(with next: QuerySetHeaderComponent) -> Bool {
        return data != next.data
    }
    
}
