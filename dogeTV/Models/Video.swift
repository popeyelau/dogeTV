//
//  Video.swift
//  dogeTV
//
//  Created by Popeye Lau on 2019/3/16.
//  Copyright © 2019 Popeye Lau. All rights reserved.
//

import Foundation

struct Video: Decodable, Equatable {
    let id: String
    let name: String
    let actor: String
    let director: String
    let cover: String
    let desc: String
    let area: String
    let year: String
    let tag: String
    let score: String
    let state: String
    let source: Int
}

struct VideoDetail: Decodable {
    let info: Video
    let recommends: [Video]?
}


struct VideoCategory: Decodable {
    var query: [OptionSet]?
    let items: [Video]
}
