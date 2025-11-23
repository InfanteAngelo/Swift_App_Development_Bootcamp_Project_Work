//
//  Placemark.swift
//  DoggoFinder
//
//  Created by Studente on 20/07/24.
//

import SwiftData
import MapKit

@Model
class Placemark: Identifiable {
    var id = UUID()
    var name: String
    var address: String
    var latitude: Double
    var longitude: Double
    var idAnnuncio: String?
    
    init(name: String, address: String, latitude: Double, longitude: Double, idAnnuncio: String?) {
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.idAnnuncio = idAnnuncio
    }
    
    var coordinate: CLLocationCoordinate2D {
        .init(latitude: latitude, longitude: longitude)
    }
}
