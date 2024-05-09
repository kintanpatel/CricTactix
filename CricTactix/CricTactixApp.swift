//
//  CricTactixApp.swift
//  CricTactix
//
//  Created by kintan on 04/05/24.
//

import SwiftUI

@main
struct BeastAppWrapper {
    static func main() {
        if #available(iOS 14.0, *) {
            CricTactixApp.main()
        }
        else {
            UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(SceneDelegate.self))
        }
    }
}
@available(iOS 14.0, *)
struct CricTactixApp: App {
    var body: some Scene {
        WindowGroup{
            ContentView()
        }
    }
}

