//
//  DoggoFinderApp.swift
//  DoggoFinder
//
//  Created by Studente on 09/07/24.
//

import SwiftUI
import Firebase


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
 

@main

struct DoggoFinderApp: App {
    
    @StateObject private var dataManager = DataManager()
    @StateObject private var authViewModel = AuthViewModel()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataManager)
                .environmentObject(authViewModel)
        }
        .modelContainer(for: Placemark.self)
    }
}
