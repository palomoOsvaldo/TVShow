//
//  AppDelegate.swift
//  TVShow
//
//  Created by Osvaldo Salas on 16/03/22.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if let user = UserDefaults.standard.string(forKey: Constants.user) {
            self.window?.rootViewController = HomeRouter.createModule()
        } else {
            self.window?.rootViewController = LoginRouter.createModule()
        }
        
        self.window?.makeKeyAndVisible()
        return true
    }


}

