//
//  FormSwitchComponent.swift
//  dogeTV
//
//  Created by Popeye Lau on 2019/4/11.
//  Copyright © 2019 Popeye Lau. All rights reserved.
//

import UIKit
import SnapKit
import Carbon


class FormSwitchComponent: IdentifiableComponent {
    typealias Content = FormSwitchContentView
    
    var id: String {
        return title
    }
    
    var title: String
    var isOn: Bool
    var onSwitch: (Bool) -> Void
    
    init(title: String, isOn: Bool = false, onSwitch: @escaping (Bool) -> Void) {
        self.title = title
        self.isOn = isOn
        self.onSwitch = onSwitch
    }
    
    func renderContent() -> Content {
        let content = Content()
        content.titleLabel.text = title
        content.switchCtrl.isOn = isOn
        content.onSwitch = onSwitch
        return content
    }
    
    func render(in content: Content) {
        
    }
    
    func referenceSize(in bounds: CGRect) -> CGSize? {
        return CGSize(width: bounds.width, height: 44)
    }
    
    func shouldContentUpdate(with next: FormSwitchComponent) -> Bool {
        return title != next.title
    }
}


class FormSwitchContentView: UIView {
    var onSwitch: ((Bool) -> Void)?

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.theme_textColor = AppColor.textColor
        return label
    }()
    
    lazy var switchCtrl: UISwitch = {
        let switchCtrl  = UISwitch()
        switchCtrl.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        return switchCtrl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(switchCtrl)
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
        }
        switchCtrl.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-16)
        }
    }
    
    @objc func switchValueChanged(_ sender: UISwitch) {
        onSwitch?(sender.isOn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
