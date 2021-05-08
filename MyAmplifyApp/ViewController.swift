//
//  ViewController.swift
//  MyAmplifyApp
//
//  Created by MacGza on 05/05/21.
//

import UIKit
import Amplify

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        recordEvents()
    }


}


// MARK: ViewController Extension
extension ViewController {
    func recordEvents() {
        let properties: AnalyticsProperties = [
            "eventPropertyStringKey": "eventPropertyStringValue",
            "eventPropertyIntKey": 123,
            "eventPropertyDoubleKey": 12.34,
            "eventPropertyBoolKey": true
        ]
        let event = BasicAnalyticsEvent(name: "eventName", properties: properties)
        
        Amplify.Analytics.record(event: event)
    }
}
