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

    let window = UIWindow(windowScene: windowScene)
    window.rootViewController = UINavigationController(rootViewController: CCCViewController())
//    window.rootViewController = CCCViewController() // 메인 뷰컨트롤러
    self.window = window
    window.makeKeyAndVisible()
  }
}
