//
//  DataManager.swift
//  DoggoFinder
//
//  Created by Studente on 14/07/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import CoreLocation

class DataManager: ObservableObject {
    @Published var annunci: [Annuncio] = []
    @Published var infoUtente: [String:String] = [:]
    @Published var isBusy: Bool = false
    @Published var myAnnunci: [Annuncio] = []
    
    
    init(){
        fetchAnnunci()
        fetchInfoUtente()
    }
    
    func fetchAnnunci(){
        isBusy = true
        annunci.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Annunci")
        
        ref.getDocuments{ snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let id = data["id"] as? String ?? ""
                    let nome = data["nome"] as? String ?? nil
                    let immagine = data["immagine"] as? String ?? nil
                    let razza = data["razza"] as? String ?? ""
                    let proprietario = data["proprietario"] as? String ?? ""
                    let città = data["città"] as? String ?? ""
                    let provincia = data["provincia"] as? String ?? ""
                    let telefono = data["telefono"] as? String ?? ""
                    let email = data["email"] as? String ?? ""
                    let idProprietario = data["idProprietario"] as? String ?? ""
                    let note = data["note"] as? String ?? nil
                    let latitudine = data["latitudine"] as? Double ?? nil
                    let longitudine = data["longitudine"] as? Double ?? nil
                    let dataPubblicazione = data["data"] as? String ?? ""
                    
                    let annuncio = Annuncio(id: UUID(uuidString: id)!, nome: nome, immagine: immagine, razza: razza, proprietario: proprietario, città: città, provincia: provincia, telefono: telefono, email: email, idProprietario: idProprietario, note: note, latitudine: latitudine, longitudine: longitudine, dataPubblicazione: self.stringToDate(data: dataPubblicazione) ?? Date())
                    
                    let dataAggiornamento = self.currentDate()
                    let oraAggiornamento = self.currentTime()
                    UserDefaults.standard.setValue(dataAggiornamento, forKey: "dataAggiornamento")
                    UserDefaults.standard.setValue(oraAggiornamento, forKey: "oraAggiornamento")
                    
                    self.annunci.append(annuncio)
                }
                self.annunci = Array(Set(self.annunci))
                self.isBusy = false
            }
        }
    }
    
    func fetchInfoUtente(){
        let email = getUserEmail()
        if let email = email {
            addInfoUtenteLogin(email: email)
        } else {
            if let id = UserDefaults.standard.string(forKey: "idOspite") {
                addInfoUtenteOspite(id: id)
            }
        }
    }
    
    func addInfoUtenteRegistrazione(utente: Utente){
        let db = Firestore.firestore()
        
        let ref = db.collection("Utenti").document(utente.id.uuidString)
        ref.setData(["id": utente.id.uuidString, "immagine": utente.immagine ?? "", "nome": utente.nome ?? "", "cognome": utente.cognome ?? "", "email": utente.email ?? "","telefono": utente.telefono ?? ""]) {
            error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        infoUtente["id"] = utente.id.uuidString
        infoUtente["immagine"] = utente.immagine ?? ""
        infoUtente["nome"] = utente.nome ?? ""
        infoUtente["cognome"] = utente.cognome ?? ""
        infoUtente["email"] = utente.email ?? ""
        infoUtente["telefono"] = utente.telefono ?? ""
    }
    
    func addInfoUtenteLogin(email: String){
        let db = Firestore.firestore()
        let ref = db.collection("Utenti")
        
        ref.getDocuments{ snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let id = data["id"] as? String ?? ""
                    let emailData = data["email"] as? String ?? ""
                    let immagine = data["immagine"] as? String ?? ""
                    let nome = data["nome"] as? String ?? ""
                    let cognome = data["cognome"] as? String ?? ""
                    let telefono = data["telefono"] as? String ?? ""
                    
                    if emailData == email {
                        self.infoUtente["id"] = id
                        self.infoUtente["email"] = email
                        self.infoUtente["immagine"] = immagine
                        self.infoUtente["nome"] = nome
                        self.infoUtente["cognome"] = cognome
                        self.infoUtente["telefono"] = telefono
                        
                        if let idOspite = UserDefaults.standard.string(forKey: "idOspite"){
                            self.cambioIdAnnuncio(oldIDUtente: idOspite, newIDUtente: id)
                            UserDefaults.standard.removeObject(forKey: "idOspite")
                            self.deleteUtenteOspite(id: idOspite)
                        }
                        
                        return
                    }
                }
            }
        }
        
        fetchAnnunci()
    }
    
    func addInfoUtenteOspite(id: String){
        
        let utente = Utente(id: UUID(uuidString: id)!)
        addInfoUtenteRegistrazione(utente: utente)
        
    }
    
    func addAnnuncio(annuncio: Annuncio){
        let db = Firestore.firestore()
        let ref = db.collection("Annunci").document(annuncio.id.uuidString)
        ref.setData(["id": annuncio.id.uuidString, "nome": annuncio.nome ?? "", "immagine": annuncio.immagine ?? "", "razza": annuncio.razza, "proprietario": annuncio.proprietario, "città": annuncio.città, "provincia": annuncio.provincia, "telefono": annuncio.telefono, "email": annuncio.email, "idProprietario": annuncio.idProprietario, "note": annuncio.note ?? "", "latitudine": annuncio.latitudine ?? "", "longitudine": annuncio.longitudine ?? "", "data": self.dateToString(data: annuncio.dataPubblicazione)]) {
            error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        fetchAnnunci()
    }
    
    func deleteUtenteOspite(id: String){
        
        let db = Firestore.firestore()
        let ref = db.collection("Utenti").document(id)
        ref.delete()
        
    }
    
    func deleteAnnuncio(annuncio: Annuncio){
        
        let db = Firestore.firestore()
        let ref = db.collection("Annunci").document(annuncio.id.uuidString)
        ref.delete()
        fetchAnnunci()
    }
    
    func cambioIdAnnuncio(oldIDUtente: String, newIDUtente: String){
        isBusy = true 
        let db = Firestore.firestore()
        let ref = db.collection("Annunci").whereField("idProprietario", isEqualTo: oldIDUtente)
        ref.getDocuments{ snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    document.reference.updateData([
                        "idProprietario": newIDUtente
                    ])
                }
            }
            self.fetchAnnunci()
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
    
    func currentDate() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "it_IT")
        return dateFormatter.string(from: now)
    }
    
    func currentTime() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
        dateFormatter.locale = Locale(identifier: "it_IT")
        return dateFormatter.string(from: now)
    }
    
    func stringToDate(data: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "it_IT")
        return dateFormatter.date(from: data)
    }
    
    func dateToString(data: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "it_IT")
        return dateFormatter.string(from: data)
    }
}
