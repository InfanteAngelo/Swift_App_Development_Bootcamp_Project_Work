//
//  Utente.swift
//  DoggoFinder
//
//  Created by Studente on 20/07/24.
//

import SwiftUI

struct Utente : Identifiable, Codable {
    var id = UUID()
    var nome: String?
    var immagine: String?
    var cognome: String?
    var email: String?
    var telefono: String?
}
