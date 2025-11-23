//
//  GestioneAccesso.swift
//  DoggoFinder
//
//  Created by Studente on 16/07/24.
//

import SwiftUI
import Firebase

struct GestioneAccesso: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var dataManager: DataManager
    
    @State private var mod: Bool = true
    @State private var emailRegistrazione: String = ""
    @State private var passwordRegistrazione: String = ""
    @State private var confermaPasswordRegistrazione: String = ""
    @State private var nomeRegistrazione: String = ""
    @State private var cognomeRegistrazione: String = ""
    @State private var telefonoRegistrazione: String = ""
    @State private var emailAccesso: String = ""
    @State private var passwordAccesso: String = ""
    @State private var alertRegistrazione: String?
    @State private var emailVuotaRegistrazione: String?
    @State private var passwordVuotaRegistrazione: String?
    @State private var confermaPasswordVuotaRegistrazione: String?
    @State private var numeroDiTelefonoNonValido: String?
    @State private var lunghezzaPrecedente: Int = 0
    @State private var alertAccesso: String?
    @State private var emailVuotaAccesso: String?
    @State private var passwordVuotaAccesso: String?
    
    var body: some View {
        
        if authViewModel.isLoggedIn || authViewModel.isOspite {
            PaginaPrincipale()
                .navigationBarBackButtonHidden()
        } else {
            
            NavigationStack{
                VStack{
                    
                    if dataManager.isBusy {
                        
                        ProgressView()
                        
                    } else {
                        
                        VStack (spacing: 20) {
                            Text("Benvenuto")
                                .foregroundStyle(.white)
                                .font(.system(size: 40, weight: .bold, design: .rounded))
                                .padding(.bottom, 75)
                            
                            if mod {
                                HStack{
                                    
                                    HStack {
                                        
                                        Image(systemName: "person.text.rectangle")
                                            .foregroundStyle(.white)
                                        
                                        
                                        TextField("", text: $nomeRegistrazione)
                                            .autocorrectionDisabled(true)
                                            .foregroundStyle(.white)
                                            .textFieldStyle(.plain)
                                            .placeholder(when: nomeRegistrazione.isEmpty){
                                                Text("Nome")
                                                    .foregroundStyle(.white)
                                                    .bold()
                                            }
                                    }
                                    
                                    HStack {
                                        
                                        Image(systemName: "person.text.rectangle")
                                            .foregroundStyle(.white)
                                        
                                        
                                        TextField("", text: $cognomeRegistrazione)
                                            .autocorrectionDisabled(true)
                                            .foregroundStyle(.white)
                                            .textFieldStyle(.plain)
                                            .placeholder(when: cognomeRegistrazione.isEmpty){
                                                Text("Cognome")
                                                    .foregroundStyle(.white)
                                                    .bold()
                                            }
                                    }
                                }
                                
                                Rectangle()
                                    .frame(width: 350, height: 1)
                                    .foregroundStyle(.white)
                                
                                HStack {
                                    
                                    Image(systemName: "phone")
                                        .foregroundStyle(.white)
                                    
                                    
                                    TextField("", text: $telefonoRegistrazione)
                                        .keyboardType(.numberPad)
                                        .autocorrectionDisabled(true)
                                        .textInputAutocapitalization(.never)
                                        .foregroundStyle(.white)
                                        .textFieldStyle(.plain)
                                        .placeholder(when: telefonoRegistrazione.isEmpty){
                                            Text("Telefono")
                                                .foregroundStyle(.white)
                                                .bold()
                                        }
                                }
                                .onChange(of: telefonoRegistrazione){
                                    if  telefonoRegistrazione.count > lunghezzaPrecedente && telefonoRegistrazione.count == 3 {
                                        telefonoRegistrazione.append(" ")
                                    }
                                    if telefonoRegistrazione.count > lunghezzaPrecedente && telefonoRegistrazione.count == 7 {
                                        telefonoRegistrazione.append(" ")
                                    }
                                    
                                    lunghezzaPrecedente = telefonoRegistrazione.count
                                }
                                
                                Rectangle()
                                    .frame(width: 350, height: 1)
                                    .foregroundStyle(.white)
                                
                                if let numeroDiTelefonoNonValido = numeroDiTelefonoNonValido {
                                    Text(numeroDiTelefonoNonValido)
                                        .foregroundStyle(Color("color8"))
                                        .bold()
                                        .font(.caption)
                                }
                                
                                HStack {
                                    
                                    Image(systemName: "envelope")
                                        .foregroundStyle(.white)
                                    
                                    
                                    TextField("", text: $emailRegistrazione)
                                        .keyboardType(.emailAddress)
                                        .autocorrectionDisabled(true)
                                        .textInputAutocapitalization(.never)
                                        .foregroundStyle(.white)
                                        .textFieldStyle(.plain)
                                        .placeholder(when: emailRegistrazione.isEmpty){
                                            Text("Email *")
                                                .foregroundStyle(.white)
                                                .bold()
                                        }
                                }
                                
                                Rectangle()
                                    .frame(width: 350, height: 1)
                                    .foregroundStyle(.white)
                                
                                if let emailVuotaRegistrazione = emailVuotaRegistrazione {
                                    Text(emailVuotaRegistrazione)
                                        .foregroundStyle(Color("color8"))
                                        .bold()
                                        .font(.caption)
                                }
                                
                                HStack{
                                    
                                    Image(systemName: "lock")
                                        .foregroundStyle(.white)
                                    
                                    SecureField("", text: $passwordRegistrazione)
                                        .foregroundStyle(.white)
                                        .textFieldStyle(.plain)
                                        .autocorrectionDisabled(true)
                                        .textInputAutocapitalization(.never)
                                        .placeholder(when: passwordRegistrazione.isEmpty){
                                            Text("Password *")
                                                .foregroundStyle(.white)
                                                .bold()
                                        }
                                }
                                
                                Rectangle()
                                    .frame(width: 350, height: 1)
                                    .foregroundStyle(.white)
                                
                                if let passwordVuotaRegistrazione = passwordVuotaRegistrazione {
                                    Text(passwordVuotaRegistrazione)
                                        .foregroundStyle(Color("color8"))
                                        .bold()
                                        .font(.caption)
                                }
                                
                                HStack {
                                    
                                    Image(systemName: "lock")
                                        .foregroundStyle(.white)
                                    
                                    SecureField("", text: $confermaPasswordRegistrazione)
                                        .foregroundStyle(.white)
                                        .textFieldStyle(.plain)
                                        .autocorrectionDisabled(true)
                                        .textInputAutocapitalization(.never)
                                        .placeholder(when: confermaPasswordRegistrazione.isEmpty){
                                            Text("Conferma Password *")
                                                .foregroundStyle(.white)
                                                .bold()
                                        }
                                    
                                }
                                
                                Rectangle()
                                    .frame(width: 350, height: 1)
                                    .foregroundStyle(.white)
                                
                                if let confermaPasswordVuotaRegistrazione = confermaPasswordVuotaRegistrazione {
                                    Text(confermaPasswordVuotaRegistrazione)
                                        .foregroundStyle(Color("color8"))
                                        .bold()
                                        .font(.caption)
                                }
                                
                                Button(action: {
                                    register()
                                }, label: {
                                    Text("Registrati")
                                        .bold()
                                        .frame(width: 200, height: 40)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                .fill(Color("color3"))
                                        )
                                        .foregroundStyle(.white)
                                })
                                
                                if let alertRegistrazione = alertRegistrazione {
                                    Text(alertRegistrazione)
                                        .foregroundStyle(Color("color8"))
                                        .bold()
                                        .font(.caption)
                                }
                                
                                HStack {
                                    Text("Hai già un account?")
                                        .foregroundStyle(.white)
                                    
                                    Button(action: {
                                        mod = false
                                    }){
                                        Text("Accedi")
                                            .bold()
                                            .underline()
                                            .foregroundStyle(.white)
                                    }
                                }
                                
                                HStack {
                                    Text("Oppure")
                                        .foregroundStyle(.white)
                                    
                                    Button(action: {
                                        accessoOspite()
                                    }){
                                        Text("continua come ospite")
                                            .bold()
                                            .underline()
                                            .foregroundStyle(.white)
                                    }
                                }
                                
                                Text("* campo obbligatorio")
                                    .font(.caption)
                                    .foregroundStyle(.white)
                            } else {
                                HStack {
                                    
                                    Image(systemName: "envelope")
                                        .foregroundStyle(.white)
                                    
                                    
                                    TextField("", text: $emailAccesso)
                                        .keyboardType(.emailAddress)
                                        .foregroundStyle(.white)
                                        .textFieldStyle(.plain)
                                        .autocorrectionDisabled(true)
                                        .textInputAutocapitalization(.never)
                                        .placeholder(when: emailAccesso.isEmpty){
                                            Text("Email")
                                                .foregroundStyle(.white)
                                                .bold()
                                        }
                                }
                                
                                Rectangle()
                                    .frame(width: 350, height: 1)
                                    .foregroundStyle(.white)
                                
                                if let emailVuotaAccesso = emailVuotaAccesso {
                                    Text(emailVuotaAccesso)
                                        .foregroundStyle(Color("color8"))
                                        .bold()
                                        .font(.caption)
                                }
                                
                                HStack {
                                    
                                    Image(systemName: "lock")
                                        .foregroundStyle(.white)
                                    
                                    SecureField("", text: $passwordAccesso)
                                        .foregroundStyle(.white)
                                        .textFieldStyle(.plain)
                                        .autocorrectionDisabled(true)
                                        .textInputAutocapitalization(.never)
                                        .placeholder(when: passwordAccesso.isEmpty){
                                            Text("Password")
                                                .foregroundStyle(.white)
                                                .bold()
                                        }
                                    
                                }
                                
                                Rectangle()
                                    .frame(width: 350, height: 1)
                                    .foregroundStyle(.white)
                                
                                if let passwordVuotaAccesso = passwordVuotaAccesso {
                                    Text(passwordVuotaAccesso)
                                        .foregroundStyle(Color("color8"))
                                        .bold()
                                        .font(.caption)
                                }
                                
                                Button(action: {
                                    login()
                                }, label: {
                                    Text("Accedi")
                                        .bold()
                                        .frame(width: 200, height: 40)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                .fill(Color("color3"))
                                        )
                                        .foregroundStyle(.white)
                                })
                                
                                if let alertAccesso = alertAccesso {
                                    Text(alertAccesso)
                                        .foregroundStyle(Color("color8"))
                                        .bold()
                                        .font(.caption)
                                }
                                
                                HStack {
                                    Text("Non hai un account?")
                                        .foregroundStyle(.white)
                                    
                                    Button(action: {
                                        mod = true
                                    }){
                                        Text("Registrati")
                                            .bold()
                                            .underline()
                                            .foregroundStyle(.white)
                                    }
                                }
                                
                                HStack {
                                    Text("Oppure")
                                        .foregroundStyle(.white)
                                    
                                    Button(action: {
                                        accessoOspite()
                                    }){
                                        Text("continua come ospite")
                                            .bold()
                                            .underline()
                                            .foregroundStyle(.white)
                                    }
                                }
                            }
                            
                        }
                        .frame(width: 350)
                    }
                }
                .onAppear(){
                    let dict = dataManager.infoUtente
                    let idUtente = dict["id"] ?? ""
                    
                    dataManager.myAnnunci.removeAll()
                    
                    for annuncio in dataManager.annunci {
                        if annuncio.idProprietario == idUtente {
                            if let index = dataManager.myAnnunci.firstIndex(where: {$0.id == annuncio.id}){
                                dataManager.myAnnunci[index] = annuncio
                            } else {
                                dataManager.myAnnunci.append(annuncio)
                            }
                        }
                    }
                }
                .onChange(of: dataManager.isBusy){
                    if !dataManager.isBusy{
                        let dict = dataManager.infoUtente
                        let idUtente = dict["id"] ?? ""
                        
                        dataManager.myAnnunci.removeAll()
                        
                        for annuncio in dataManager.annunci {
                            if annuncio.idProprietario == idUtente {
                                if let index = dataManager.myAnnunci.firstIndex(where: {$0.id == annuncio.id}){
                                    dataManager.myAnnunci[index] = annuncio
                                } else {
                                    dataManager.myAnnunci.append(annuncio)
                                }
                            }
                        }
                    }
                }

                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(LinearGradient(gradient: Gradient(colors: [
                    Color(mod ? "color1" : "color2"),
                    Color(mod ? "color2" : "color1")
                ]), startPoint: .top, endPoint: .bottom))
            }
        }
    }
    
    func register(){
        
        var check: Bool = true
        
        if emailRegistrazione.isEmpty {
            check = false
            emailVuotaRegistrazione = "Inserire un'email valida"
        }else {
            emailVuotaRegistrazione = nil
            if !validateEmail(email: emailRegistrazione){
                check = false
                alertRegistrazione = "Email non valida, riprovare"
            } else {
                alertRegistrazione = nil
            }
        }
        if passwordRegistrazione.isEmpty {
            check = false
            passwordVuotaRegistrazione = "Inserire una password valida"
        } else {
            passwordVuotaRegistrazione = nil
        }
        if confermaPasswordRegistrazione.isEmpty || confermaPasswordRegistrazione != passwordRegistrazione{
            check = false
            confermaPasswordVuotaRegistrazione = "Inserire la conferma della password valida"
        } else {
            confermaPasswordVuotaRegistrazione = nil
        }
        
        if !telefonoRegistrazione.isEmpty{
            if !validatePhoneNumber(telefono: telefonoRegistrazione){
                check = false
                numeroDiTelefonoNonValido = "Numero di telefono inserito non valido"
            } else {
                numeroDiTelefonoNonValido = nil
            }
        } else {
            numeroDiTelefonoNonValido = nil
        }
        
        if check {
            Auth.auth().createUser(withEmail: emailRegistrazione, password: passwordRegistrazione) {
                result, error in
                if let error = error {
                    print(error.localizedDescription)
                    alertRegistrazione = checkErrore(errore: error.localizedDescription)
                } else {
                    
                    UserDefaults.standard.set(true, forKey: "CheckPrimoAccesso")
                    
                    
                    var utente: Utente
                    if let id = UserDefaults.standard.string(forKey: "idOspite") {
                        utente = Utente(id: UUID(uuidString: id)!,nome: nomeRegistrazione, immagine: nil, cognome: cognomeRegistrazione, email: emailRegistrazione, telefono: telefonoRegistrazione)
                        UserDefaults.standard.removeObject(forKey: "idOspite")
                    } else {
                        utente = Utente(nome: nomeRegistrazione, immagine: nil, cognome: cognomeRegistrazione, email: emailRegistrazione, telefono: telefonoRegistrazione)
                    }
                    
                    dataManager.addInfoUtenteRegistrazione(utente: utente)
                    
                    authViewModel.fetchState()
                }
            }
        }
    }
    
    func login(){
        
        var check: Bool = true
        
        if emailAccesso.isEmpty {
            check = false
            emailVuotaAccesso = "Inserire un'email valida"
        }else {
            emailVuotaAccesso = nil
            if !validateEmail(email: emailAccesso){
                check = false
                alertAccesso = "Email non valida, riprovare"
            } else {
                alertAccesso = nil
            }
        }
        if passwordAccesso.isEmpty {
            check = false
            passwordVuotaAccesso = "Inserire una password valida"
        } else {
            passwordVuotaAccesso = nil
        }
        
        if check{
            Auth.auth().signIn(withEmail: emailAccesso, password: passwordAccesso) {
                result, error in
                
                if let error = error {
                    print(error.localizedDescription)
                    alertAccesso = checkErrore(errore: error.localizedDescription)
                } else {
                    
                    UserDefaults.standard.set(true, forKey: "CheckPrimoAccesso")
                    
                    dataManager.addInfoUtenteLogin(email: emailAccesso)
                    
                    authViewModel.fetchState()
                }
            }
        }
        
    }
    
    func accessoOspite(){
        if let id = UserDefaults.standard.string(forKey: "idOspite") {
            dataManager.addInfoUtenteOspite(id: id)
        } else {
            let newId = UUID()
            dataManager.addInfoUtenteOspite(id: newId.uuidString)
            UserDefaults.standard.setValue(newId.uuidString, forKey: "idOspite")
        }
        UserDefaults.standard.setValue(true, forKey: "isOspite")
        authViewModel.isOspite = true
    }
    
    func checkErrore(errore: String) -> String {
        switch errore {
        case "The email address is already in use by another account.":
            return "Email già in uso, riprovare."
        case "The password must be 6 characters long or more.":
            return "Password non valida, deve contenere almeno 6 caratteri, riprovare."
        case "The email address is badly formatted.":
            return "Email non valida, riprovare."
        case "The supplied auth credential is malformed or has expired.":
            return "Credenziali inserite non valide, riprovare."
        case "Network error (such as timeout, interrupted connection or unreachable host) has occurred.":
            return "Errore di connessione, riprovare."
        default:
            return "Errore, riprovare."
        }
    }
}
