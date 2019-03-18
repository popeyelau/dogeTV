//
//  QueryOption.swift
//  dogeTV
//
//  Created by Popeye Lau on 2019/3/18.
//  Copyright © 2019 Popeye Lau. All rights reserved.
//

import Foundation

enum OptionSetType: String, CaseIterable {
    case tag = "类型"
    case area = "地区"
    case year = "年份"
    case topic = "主题"
}

class OptionSet: Decodable {
    var title: String
    var options: [Option]
    
    func setSelected(item: Option) {
        deSelectAllOptions()
        item.isSelected = true
    }
    
    func deSelectAllOptions() {
        options.forEach { $0.isSelected = false}
    }
}

class Option: Decodable, Equatable {
    static func == (lhs: Option, rhs: Option) -> Bool {
        return lhs.key == rhs.key
    }
    var text: String
    var key: String
    var isSelected = false
    
    enum CodingKeys: String, CodingKey {
        case text
        case key
    }
}
