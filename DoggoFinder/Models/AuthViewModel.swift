//
//  AuthViewModel.swift
//  DoggoFinder
//
//  Created by Studente on 15/07/24.
//

import SwiftUI
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var isOspite: Bool = false
    
    init(){
        fetchState()
    }
    
    func fetchState(){
        self.isLoggedIn = Auth.auth().currentUser != nil
    }
    
    func logout(){
        do {
            try Auth.auth().signOut()
            self.isLoggedIn = false
        } catch let error as NSError{
            print("Error logout", error)
        }
    }
    
    func getUserEmail() -> String? {
        if let user = Auth.auth().currentUser {
            let email = user.email ?? nil
            return email
        } else {
            return nil
        }
    }
}


