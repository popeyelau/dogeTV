//
//  AppDelegate.swift
//  dogeTV
//
//  Created by Popeye Lau on 2019/3/14.
//  Copyright © 2019 Popeye Lau. All rights reserved.
//

import UIKit
import PKHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let root = HomeViewController()
        window?.rootViewController = UINavigationController(rootViewController: root)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        configureUIAppearance()
        return true
    }
}


extension AppDelegate {
    func configureUIAppearance() {
        let appearance = UINavigationBar.appearance()
        appearance.prefersLargeTitles = false
        appearance.isTranslucent = true
        appearance.tintColor = .black
        if let font = UIFont(name: "PingFangSC-light", size: 20) {
            appearance.titleTextAttributes = [.font: font]
        }
        if let font = UIFont(name: "PingFangSC-light", size: 32) {
            appearance.largeTitleTextAttributes = [.font: font]
        }
        
        appearance.shadowImage = UIImage()

        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UINavigationBar.self]).setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UINavigationBar.self]).setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .highlighted)
        
        UISearchBar.appearance().tintColor = .black
        UITextField.appearance().tintColor = .black
        
        PKHUD.sharedHUD.dimsBackground = false
        PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled  = true
    }
}
