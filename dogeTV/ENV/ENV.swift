//
//  ENV.swift
//  dogeTV
//
//  Created by Popeye Lau on 2019/3/14.
//  Copyright © 2019 Popeye Lau. All rights reserved.
//

import Foundation

struct ENV {
    static let host = "http://111.231.243.232"
    static var usingnPlayer: Bool {
        get { return UserDefaults.standard.bool(forKey: "nPlayer") }
        set { UserDefaults.standard.set(newValue, forKey: "nPlayer") }
    }

}



