//
//  ViewController.swift
//  MyAmplifyApp
//
//  Created by MacGza on 05/05/21.
//

import UIKit
import Amplify
import AWSPinpointAnalyticsPlugin
import AWSPinpoint
import Combine

class ViewController: UIViewController {

    var dataSink: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //recordEvents()
        //dataSink = createTodo()
        //dataSink = getTodo()
        dataSink = listTodos()
    }


}


// MARK: ViewController Extension
extension ViewController {
    
    func listTodos() -> AnyCancellable {
        let todo = Todo.keys
        let predicate = todo.name == "my first todo" && todo.description == "todo description"
        let sink = Amplify.API
            .query(request: .paginatedList(Todo.self, where: predicate, limit: 1000))
            .resultPublisher
            .sink {
                if case let .failure(error) = $0 {
                    print("Got failed event with error \(error)")
                }
            }
            receiveValue: { result in
                switch result {
                case .success(let todos):
                    print("Successfully retrieved todos: \(todos)")
                case .failure(let error):
                    print("Got failed result with \(error.errorDescription)")
                }
                
            }
        return sink
    }
    
    func getTodo() -> AnyCancellable {
        let sink = Amplify.API
            .query(request: .get(Todo.self, byId: "16D978D3-DD7A-4909-BAB0-42A728F2BECA"))
            .resultPublisher
            .sink {
                if case let .failure(error) = $0 {
                    print("Got failed event with error \(error)")
                }
            }
            receiveValue: { result in
                switch result {
                case .success(let todo):
                    guard let todo = todo else {
                        print("Could not find todo")
                        return
                    }
                    print("Successfully retrieved todo : \(todo)")
                case .failure(let error):
                    print("Got failed result with \(error)")
                }
                
            }
        return sink
    }
    
    func createTodo() -> AnyCancellable {
        let todo = Todo(name: "my first todo", description: "todo description")
        let sink = Amplify.API.mutate(request: .create(todo))
            .resultPublisher
            .sink { completion in
                if case let .failure(error) = completion {
                    print("Failed to create graphql \(error.errorDescription)")
                }
                
            }
            receiveValue: { result in
                switch result {
                case .success(let todo):
                    print("Successfully created the todo: \(todo)")
                case .failure(let graphQLError):
                    print("Could not decode result: \(graphQLError)")
                }
                
            }
        return sink
    }
    
    func getEscapeHatch() {
        do {
            let plugin = try Amplify.Analytics.getPlugin(for: "awsPinpointAnalyticsPlugin") as! AWSPinpointAnalyticsPlugin
            
            let awsPinpoint = plugin.getEscapeHatch()
            
        } catch {
            print("Get escape hatch failed with error: \(error)")
        }
    }
    
    
    func identifyUser() {
        guard let user = Amplify.Auth.getCurrentUser() else {
            print("Could not get user, parhaps the user is not signed in")
            return
        }
        
        let location = AnalyticsUserProfile.Location(latitude: 47.606209, longitude: -122.332069, postalCode: "98122", city: "Seattle", region: "WA", country: "USA")
        
        let properties: AnalyticsProperties = ["phoneNumber": "+11234567890", "age": 25]
        
        let userProfile = AnalyticsUserProfile(name: user.username, email: "name@example.com", location: location, properties: properties)
        
        Amplify.Analytics.identifyUser(user.userId, withProfile: userProfile)
    }
    
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
