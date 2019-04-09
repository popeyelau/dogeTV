//
//  UIViewControllerExtension.swift
//  dogeTV
//
//  Created by Popeye Lau on 2019/3/4.
//  Copyright © 2019 Popeye Lau. All rights reserved.
//

import UIKit
import PKHUD
import Loaf
import SPStorkController
import PromiseKit
import Kingfisher
import Carbon

extension UIViewController {
    func showError(_ error: Error, completionHandler: ((Bool) -> Void)? = nil) {
        Loaf(error.localizedDescription, state: .error, location: .bottom, sender: self).show(.short, completionHandler: completionHandler)
    }
    
    func showInfo(_ message: String, completionHandler: ((Bool) -> Void)? = nil) {
        Loaf(message, state: .info, location: .bottom, sender: self).show(.short, completionHandler: completionHandler)
    }
    
    func showSuccess(_ message: String, completionHandler: ((Bool) -> Void)? = nil) {
        Loaf(message, state: .success, location: .bottom, sender: self).show(.short, completionHandler: completionHandler)
    }

    func push(viewController: UIViewController, animated: Bool) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func showVideo(with id: String) {
        HUD.show(.progress)
        //TODO: get video info & episodes
        attempt(maximumRetryCount: 3) {
            when(fulfilled: APIClient.fetchVideo(id: id),
                 APIClient.fetchEpisodes(id: id))
            }.done { detail, episodes in
                guard let  navigationController = self.navigationController else {
                    return
                }
                let modal = VideoDetailViewController()
                modal.detail = detail
                modal.episodes = episodes
                /*
                modal.modalPresentationCapturesStatusBarAppearance = true
                navigationController.presentAsStork(modal, height: nil, showIndicator: true, hideIndicatorWhenScroll: false, showCloseButton: false, complection: nil)*/
                navigationController.pushViewController(modal, animated: true)
            }.catch{ error in
                print(error)
                self.showError(error)
            }.finally {
                HUD.hide()
        }
    }

    func player(with streamURL: String) {
        if streamURL.isEmpty {
            showInfo("无效的地址")
            return
        }

        //nPlayer 打开
        if ENV.usingnPlayer && UIApplication.shared.canOpenURL(URL(string: "nplayer-http://")!) {
            let nPlayer = URL(string: "nplayer-\(streamURL)")!
            UIApplication.shared.open(nPlayer, options: [:], completionHandler: nil)
            return
        }

        let target = PlayerViewController()
        present(target, animated: true) {
            target.play(url: streamURL, title: nil)
        }
    }
}
