//
//  AppDelegate.swift
//  MyAmplifyApp
//
//  Created by MacGza on 05/05/21.
//

import UIKit
import Amplify
import AWSPinpointAnalyticsPlugin
import AWSCognitoAuthPlugin

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        configureAmplify()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

// Flush Events - update amplifyconfiguration.json
// default configuration flush out to the network every 60 seconds
//
//"plugins": {
//    "awsPinpointAnalyticsPlugin": {
//        "pinpointAnalytics": {
//            ...
//        },
//        "pinpointTargeting": {
//            ...
//        },
//        "autoFlushEventsInterval": 60
//}
//
// Note: If you set autoFlushEventsInterval to 0, you are responsible for calling Amplify.Analytics.flushEvents() to submit the recorded events to the backend.


// Mark: AppDelegate Extension
extension AppDelegate {
    
    // Disable Analytics
    // Analytics are sent to the backend automatically (it’s enabled by default).
    
    func disableAnalytics() {
        // To disable it call:
        Amplify.Analytics.disable()
        
        // To re-eneble it call:
        //Amplify.Analytics.enable()
    }
    
    
    // Global Properties
    // will be used across all Amplify.Analytics.record(event:) calls
    func setAnalyticsGlobalProperties() {
        let globalProperties: AnalyticsProperties = ["globalPropertyKey": "value"]
        Amplify.Analytics.registerGlobalProperties(globalProperties)
        
        print("Analytics global propierties registered")
        
        // Unregister global properties
        // Amplify.Analytics.unregisterGlobalProperties()
    }
    
    func configureAmplify() {
        do {
            Amplify.Logging.logLevel = .verbose
            
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSPinpointAnalyticsPlugin())
            
            try Amplify.configure()
            
            print("Amplify configured with Auth and Analytics plugins")
            
            setAnalyticsGlobalProperties()
        } catch {
            print("Failed to initialize Amplify with: \(error)")
        }
    }
}
