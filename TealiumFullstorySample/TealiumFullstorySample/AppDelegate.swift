//
//  AppDelegate.swift
//  TealiumFullstorySample
//
//  Created by Tyler Rister on 12/5/22.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        TealiumHelper.start()
        return true
    }
}
