//
//  Channel.swift
//  dogeTV
//
//  Created by Popeye Lau on 2019/3/3.
//  Copyright © 2019 Popeye Lau. All rights reserved.
//

import Foundation

struct Channel: Decodable {
    let name: String
    let icon: String
    let url: String
}


enum TV: Int, CaseIterable {
    case iptv
    case mainland
    case hk
    case jp
    case us

    var title: String {
        switch self {
        case .iptv:
            return "IPTV"
        case .mainland:
            return "大陆"
        case .hk:
            return "港澳台"
        case .jp:
            return "日韩"
        case .us:
            return "欧美"
        }
    }

    var key: String {
        switch self {
        case .iptv:
            return "iptv"
        case .mainland:
            return "cn"
        case .hk:
            return "hktw"
        case .jp:
            return "jpkr"
        case .us:
            return "us"
        }
    }
}
