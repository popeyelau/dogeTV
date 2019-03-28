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
import SwiftTheme


struct QueryItemComponent: IdentifiableComponent {
    typealias Content = UILabel
    
    var id: String {
        return data.key
    }
    
    let data: Option

    func renderContent() -> Content {
        let content = Content()
        content.font = .systemFont(ofSize: 12)
        content.textAlignment = .center
        content.clipsToBounds = true
        content.layer.cornerRadius = 3
        return content
    }
    
    func render(in content: Content) {
        content.text = data.text



        let textColor: ThemeColorPicker = data.isSelected ? ["#FFF", "#FFF"] :  ["#434343", "#FFF"]
        content.theme_textColor = textColor


        let backgroundColor: ThemeColorPicker = data.isSelected ? ["#434343", "#1C3242"] :  ["#4c000000", "#4c000000"]
        content.theme_backgroundColor = backgroundColor


     
    }
    
    func referenceSize(in bounds: CGRect) -> CGSize? {
        let width = data.text.widthOfString(usingFont: .systemFont(ofSize: 12)) + 10
        return CGSize(width: max(width, 50), height: 30)
    }
    
    func shouldContentUpdate(with next: QueryItemComponent) -> Bool {
        return true
    }
}




struct QuerySetHeaderComponent: Component {
    typealias Content = QuerySetHeaderContentView
    
    let data: String

    func renderContent() -> Content {
        let content = Content()
        return content
    }

    func render(in content: Content) {
        content.titleLabel.text = data
     
    }
    
    func referenceSize(in bounds: CGRect) -> CGSize? {
        return CGSize(width: bounds.width , height: 35)
    }
    
    func shouldContentUpdate(with next: QuerySetHeaderComponent) -> Bool {
        return data != next.data
    }
    
}

class QuerySetHeaderContentView: UIView {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.theme_backgroundColor = AppColor.secondaryBackgroundColor
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        let line = UIView()
        line.theme_backgroundColor = AppColor.separatorColor
        addSubview(line)
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.greaterThanOrEqualTo(50)
        }
        line.snp.makeConstraints {
            $0.height.height.equalTo(0.5)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

