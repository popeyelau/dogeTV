//
//  UIViewControllerExtension.swift
//  dogeTV
//
//  Created by Popeye Lau on 2019/3/4.
//  Copyright © 2019 Popeye Lau. All rights reserved.
//

import UIKit
import PKHUD
import SwiftMessageBar
import SPStorkController
import PromiseKit
import Kingfisher
import Carbon

extension UIViewController {
    func showError(_ error: Error) {
        SwiftMessageBar.showMessage(withTitle: "(╯°□°)╯︵ ┻━┻", message: error.localizedDescription, type: .error)
    }
    
    func showInfo(_ message: String) {
        SwiftMessageBar.showMessage(withTitle: "(╯°□°)╯︵ ┻━┻", message: message, type: .info)
    }
    
    func showVideo(with id: String) {
        HUD.show(.progress)
        //TODO: get video info & episodes
        attempt(maximumRetryCount: 3) {
            when(fulfilled: APIClient.fetchVideo(id: id),
                 APIClient.fetchEpisodes(id: id))
            }.done { video, episodes in
                guard let  navigationController = self.navigationController else {
                    return
                }
                let modal = VideoDetailViewController()
                modal.media = video
                modal.episodes = episodes
                modal.modalPresentationCapturesStatusBarAppearance = true
                navigationController.presentAsStork(modal, showIndicator: true, complection: nil)
            }.catch{ error in
                print(error)
                self.showError(error)
            }.finally {
                HUD.hide()
        }
    }
    
}
