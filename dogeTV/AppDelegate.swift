//
//  AppDelegate.swift
//  dogeTV
//
//  Created by Popeye Lau on 2019/3/14.
//  Copyright © 2019 Popeye Lau. All rights reserved.
//

import UIKit
import PKHUD
import SwiftTheme

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
        AppTheme.restore()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        AppTheme.save()
    }
}


extension AppDelegate {
    func configureUIAppearance() {
        
        UIApplication.shared.theme_setStatusBarStyle(AppColor.statusBarStyle, animated: true)
        let appearance = UINavigationBar.appearance()
        appearance.prefersLargeTitles = false
        appearance.isTranslucent = false
        
        appearance.theme_tintColor = AppColor.tintColor
        appearance.theme_barTintColor = AppColor.backgroundColor
        
        let titleAttributes = AppColor.barTextColors.map { hexString -> [NSAttributedString.Key: AnyObject] in
            return [
                .foregroundColor: UIColor(rgba: hexString),
                .font: UIFont(name: "PingFangSC-light", size: 20)!
            ]
        }
        
        appearance.shadowImage = UIImage()
        appearance.theme_titleTextAttributes = ThemeDictionaryPicker.pickerWithAttributes(titleAttributes)

        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UINavigationBar.self]).setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UINavigationBar.self]).setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .highlighted)
        
        UITextField.appearance().tintColor = .black
        
        PKHUD.sharedHUD.dimsBackground = false
        PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled  = true
    }
}
