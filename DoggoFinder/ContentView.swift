//
//  ContentView.swift
//  DoggoFinder
//
//  Created by Studente on 25/06/24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var checkPrimoAccesso = UserDefaults.standard.bool(forKey: "CheckPrimoAccesso")
    @State private var isOspite = UserDefaults.standard.bool(forKey: "isOspite")
    
    var body: some View {
        
        Group {
            if authViewModel.isLoggedIn || authViewModel.isOspite{
                PaginaPrincipale()
                    .navigationBarBackButtonHidden()
            } else {
                GestioneAccesso()
                    .navigationBarBackButtonHidden()
            }
        }
        .onAppear(){
            if !checkPrimoAccesso{
                authViewModel.logout()
            }
            if isOspite{
                authViewModel.isOspite = true
            }
        }
    }
}

extension UIImage {
    var base64: String? {
        self.jpegData(compressionQuality: 0.1)?.base64EncodedString()
    }
}

extension String {
    var imageFromBase64: UIImage? {
        guard let imageData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return UIImage(data: imageData)
    }
    
    func removeWhiteSpaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 0.5 : 0)
            self
        }
    }
    
    func dateToString(data: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "it_IT")
        return dateFormatter.string(from: data)
    }
    
    func validateEmail(email: String) -> Bool {
        let emailFormat = "^[\\w-\\.]+@[\\w-]+(\\.[\\w-]+)+$"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        let result = emailPredicate.evaluate(with: email)
        return result
    }
    
    func validatePhoneNumber(telefono: String) -> Bool {
        let numero = telefono.removeWhiteSpaces()
        
        let formato = "^[0-9]{9,10}$"
        let predicato = NSPredicate(format: "SELF MATCHES %@", formato)
        let risultato = predicato.evaluate(with: numero)
        return risultato
    }
}

