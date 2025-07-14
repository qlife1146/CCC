//
//  SceneDelegate.swift
//  CCC
//
//  Created by luca on 7/7/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene,
             willConnectTo _: UISceneSession,
             options _: UIScene.ConnectionOptions)
  {
    guard let windowScene = (scene as? UIWindowScene) else { return }

    // let lastScreen = CoreDataManager.shared.fetchLastScreen()
    let mainVC = CCCViewController()
    let nav = UINavigationController(rootViewController: mainVC)
    let window = UIWindow(windowScene: windowScene)
    window.rootViewController = nav
    self.window = window
    window.makeKeyAndVisible()
  }
}
