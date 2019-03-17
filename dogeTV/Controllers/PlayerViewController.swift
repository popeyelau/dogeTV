//
//  PlayerViewController.swift
//  dogeTV
//
//  Created by Popeye Lau on 2019/3/3.
//  Copyright © 2019 Popeye Lau. All rights reserved.
//

import UIKit
import AVKit

class PlayerViewController: AVPlayerViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func play(url: String, title: String?) {

        let player = AVPlayer(url: URL(string: url)!)
        self.player = player
        player.play()
    }

    override var shouldAutorotate: Bool {
        return true
    }
}
