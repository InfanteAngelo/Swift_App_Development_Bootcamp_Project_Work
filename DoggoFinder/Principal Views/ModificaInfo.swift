//
//  ModificaInfo.swift
//  DoggoFinder
//
//  Created by Studente on 12/07/24.
//

import SwiftUI

struct ModificaInfo: View {
    
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    
    @State var immagine: String?
    @State var email: String
    @State private var lunghezzaPrecedente: Int = 0
    @State private var numeroDiTelefonoNonValido: String?
    
    @Binding var nome: String
    @Binding var cognome: String
    @Binding var numeroDiTelefono: String
    
    var body: some View {
        NavigationStack{
            Form{
                Section(header: Text("Informazioni personali")){
                    VStack (alignment: .leading){
                        Text("Nome")
                        TextField("es: Angelo", text: $nome)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                        Text("Cognome")
                        TextField("es: Rossi", text: $cognome)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                    }
                }
                Section(header: Text("Recapiti")){
                    VStack (alignment: .leading){
                        Text("Numero di telefono")
                        TextField("es: 333 444 5555", text: $numeroDiTelefono)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                    }
                    
                    .onAppear(){
                        lunghezzaPrecedente = numeroDiTelefono.count
                    }
                    .onChange(of: numeroDiTelefono){
                        if  numeroDiTelefono.count > lunghezzaPrecedente && numeroDiTelefono.count == 3 {
                            numeroDiTelefono.append(" ")
                        }
                        if numeroDiTelefono.count > lunghezzaPrecedente && numeroDiTelefono.count == 7 {
                            numeroDiTelefono.append(" ")
                        }
                        
                        lunghezzaPrecedente = numeroDiTelefono.count
                    }
                    if let numeroDiTelefonoNonValido = numeroDiTelefonoNonValido {
                        Text(numeroDiTelefonoNonValido)
                            .foregroundStyle(Color(.red))
                            .bold()
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("Informazioni utente")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing:Button("Salva"){
                
                var check = true
                
                if !numeroDiTelefono.isEmpty {
                    if !validatePhoneNumber(telefono: numeroDiTelefono){
                        check = false
                        numeroDiTelefonoNonValido = "Numero di telefono inserito non valido"
                    } else {
                        numeroDiTelefonoNonValido = nil
                    }
                } else {
                    numeroDiTelefonoNonValido = nil
                }
                
                if check {
                    let dict = dataManager.infoUtente
                    let idUtente = dict["id"] ?? ""
                    
                    let utente = Utente(id: UUID(uuidString: idUtente)!, nome: nome, immagine: immagine ?? "", cognome: cognome, email: email, telefono: numeroDiTelefono)
                    dataManager.addInfoUtenteRegistrazione(utente: utente)
                    
                    presentationMode.wrappedValue.dismiss()
                }
            })
            .navigationBarItems(leading: Button("Annulla"){
                
                let dict = dataManager.infoUtente
                
                nome = dict["nome"] ?? ""
                cognome = dict["cognome"] ?? ""
                numeroDiTelefono = dict["telefono"] ?? ""
                
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

