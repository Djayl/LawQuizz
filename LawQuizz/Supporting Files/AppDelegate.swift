//
//  AppDelegate.swift
//  LawQuizz
//
//  Created by MacBook DS on 01/03/2020.
//  Copyright © 2020 Djilali Sakkar. All rights reserved.
//

import UIKit
import Firebase 

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        FirebaseApp.configure()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
               window = UIWindow()
               self.window?.rootViewController = storyboard.instantiateInitialViewController()
               self.window?.makeKeyAndVisible()
        
        return true
    }


}

