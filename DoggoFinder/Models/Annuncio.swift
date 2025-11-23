//
//  Annuncio.swift
//  DoggoFinder
//
//  Created by Studente on 20/07/24.
//

import SwiftUI
import CoreLocation


struct Annuncio : Identifiable, Codable, Equatable, Hashable{
    var id = UUID()
    var nome: String?
    var immagine: String?
    var razza: String
    var proprietario: String
    var città: String
    var provincia: String
    var telefono: String
    var email: String
    var idProprietario: String
    var note: String?
    var latitudine: Double?
    var longitudine: Double?
    var dataPubblicazione: Date = Date()
}
