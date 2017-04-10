//
//  AppDelegate.swift
//  SKAToolKit
//
//  Created by Marc Vandehey on 8/31/15.
//  Copyright © 2015 SpriteKit Alliance. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var button:SKAButtonSprite?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    let viewController = SKAButtonViewController()
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.backgroundColor = UIColor.white
    window?.rootViewController = viewController
    window?.makeKeyAndVisible()
    
    return true
  }
}
