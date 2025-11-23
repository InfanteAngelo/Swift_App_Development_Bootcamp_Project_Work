//
//  MapManager.swift
//  DoggoFinder
//
//  Created by Studente on 20/07/24.
//

import MapKit
import SwiftData

enum MapManager {
    @MainActor
    
    static func searchPlaces(_ modelContext: ModelContext, searchText: String, visibleRegion: MKCoordinateRegion?) async {
        removeSearchResults(modelContext: modelContext) 
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        if let visibleRegion {
            request.region = visibleRegion
        }
        
        let searchItems = try? await MKLocalSearch(request: request).start()
        let results = searchItems?.mapItems ?? []
        results.forEach {
            let Placemark = Placemark(
                name: $0.placemark.name ?? "",
                address: $0.placemark.title ?? "",
                latitude: $0.placemark.coordinate.latitude,
                longitude: $0.placemark.coordinate.longitude,
                idAnnuncio: nil
            )
            modelContext.insert(Placemark)
        }
    }
    
    static func removeSearchResults(modelContext: ModelContext) {
        let searchPredicate = #Predicate<Placemark> { $0.idAnnuncio == nil }
        try? modelContext.delete(model: Placemark.self, where: searchPredicate)
    }
}
