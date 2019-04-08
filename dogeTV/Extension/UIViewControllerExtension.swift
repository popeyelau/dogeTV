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
    func showError(_ error: Error) {
        Loaf(error.localizedDescription, state: .error, location: .bottom, sender: self).show()
    }
    
    func showInfo(_ message: String) {
        Loaf(message, state: .info, location: .bottom, sender: self).show()
    }
    
    func showSuccess(_ message: String) {
        Loaf(message, state: .success, location: .bottom, sender: self).show()
    }

    func push(viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = true
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
}
