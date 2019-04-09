//
//  EmptyComponent.swift
//  dogeTV
//
//  Created by Popeye Lau on 2019/4/9.
//  Copyright © 2019 Popeye Lau. All rights reserved.
//

import UIKit
import SnapKit
import Carbon


struct EmptyComponent: IdentifiableComponent {
    typealias Content = EmptyContentView
    
    var id: String {
        return text
    }
    
    var text: String
    var icon: UIImage
    
    init(icon: UIImage = UIImage(named: "empty")!, text: String = "🤪 什么也木有") {
        self.icon = icon
        self.text = text
    }
    
    func renderContent() -> Content {
        let content = Content()
        content.emptyImageView.image = icon
        content.textLabel.text = text
        return content
    }
    
    func render(in content: Content) {
        
    }
    
    func referenceSize(in bounds: CGRect) -> CGSize? {
        return CGSize(width: bounds.width, height: bounds.height * 0.6)
    }
    
    func shouldContentUpdate(with next: EmptyComponent) -> Bool {
        return false
    }
}


class EmptyContentView: UIView {
    lazy var emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.theme_tintColor = AppColor.secondaryTextColor
        return imageView
    }()
    

    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.theme_textColor = AppColor.secondaryTextColor
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(emptyImageView)
        addSubview(textLabel)
        
        emptyImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.snp.centerY)
        }
        
        textLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.top.equalTo(self.snp.centerY).offset(16)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
