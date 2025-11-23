//
//  Mappa.swift
//  DoggoFinder
//
//  Created by Studente on 20/07/24.
//

import SwiftUI
import MapKit
import SwiftData

struct Mappa: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var dataManager: DataManager
    
    @StateObject private var locationManager = LocationManager()
    @Query(filter: #Predicate<Placemark> {$0.idAnnuncio == nil}) private var searchPlacemarks: [Placemark]
    
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var visibleRegion: MKCoordinateRegion?
    @State private var searchText = ""
    @State private var markerAnnunci: [Placemark] = []
    @State var networkMonitor = NetworkMonitor()
    @State private var selectedPlacemark: Placemark?
    @State private var showPermissionDeniedAlert = false
    @State private var alertMessage = ""
    @State private var ricerca: Int = -1
    @State static var refreshFlag: Bool = false
    
    private var listPlacemarks: [Placemark] {
        searchPlacemarks + markerAnnunci
    }
    
    var body: some View {
        if networkMonitor.isConnected {
            if dataManager.isBusy {
                ProgressView()
            } else {
                NavigationStack{
                    VStack{
                        Map(position: $cameraPosition, selection: $selectedPlacemark) {
                            UserAnnotation()
                            
                            ForEach(listPlacemarks, id: \.id){
                                placemark in
                                Group {
                                    if placemark.idAnnuncio != nil{
                                        Marker(coordinate: placemark.coordinate){
                                            Label(placemark.name, systemImage: "pawprint.fill")
                                        }
                                        .tint(.yellow)
                                    } else {
                                        Marker(placemark.name, coordinate: placemark.coordinate)
                                    }
                                }
                                .tag(placemark)
                            }
                        }
                        .onAppear {
                            markerAnnunci.removeAll()
                            
                            for annuncio in dataManager.annunci {
                                if let latitudine = annuncio.latitudine, let longitudine = annuncio.longitudine {
                                    let newMarkerAnnuncio = Placemark(name: annuncio.razza, address: annuncio.città, latitude: latitudine, longitude: longitudine, idAnnuncio: annuncio.id.uuidString)
                                    markerAnnunci.append(newMarkerAnnuncio)
                                }
                            }
                            
                            MapManager.removeSearchResults(modelContext: modelContext)
                            locationManager.checkLocationAuthorization()
                            ricerca = -1
                            
                            if locationManager.permission == "restricted" || locationManager.permission == "denied" {
                                alertMessage = "L'accesso alla posizione è stato negato. Per favore, abilitalo nelle impostazioni per un miglior utilizzo della mappa."
                                showPermissionDeniedAlert = true
                            }
                        }
                        .border(Color.black)
                        .mapControls {
                            MapUserLocationButton()
                        }
                        .sheet(item: $selectedPlacemark) { selectedPlacemark in
                            
                            if let id = selectedPlacemark.idAnnuncio {
                                if let annuncio = dataManager.annunci.first(where: {$0.id.uuidString == id}){
                                    StrutturaAnnuncio(annuncio: annuncio, paginaPrecedente: "Mappa")
                                }
                            } else {
                                LocationDetailView(
                                    idAnnuncio: selectedPlacemark.idAnnuncio,
                                    selectedPlacemark: selectedPlacemark
                                )
                                .presentationDetents([.height(450)])
                            }
                            
                        }
                        .alert(isPresented: $showPermissionDeniedAlert) {
                            Alert(
                                title: Text("Accesso alla posizione non fornito"),
                                message: Text(alertMessage),
                                primaryButton: .default(Text("Vai a Impostazioni")) {
                                    if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                                        UIApplication.shared.open(appSettings)
                                    }
                                },
                                secondaryButton: .cancel(Text("Annulla"))
                            )
                        }
                        .onMapCameraChange(frequency: .onEnd){ context in
                            visibleRegion = context.region
                        }
                        .onDisappear {
                            MapManager.removeSearchResults(modelContext: modelContext)
                        }
                    }
                    .toolbar{
                        ToolbarItem(placement: .topBarTrailing){
                            Menu{
                                
                                Button(action:{
                                    searchText = "pet store"
                                    Task {
                                        await MapManager.searchPlaces(
                                            modelContext,
                                            searchText: searchText,
                                            visibleRegion: visibleRegion
                                        )
                                        searchText = ""
                                        ricerca = 0
                                        cameraPosition = .userLocation(fallback: .automatic)
                                    }
                                }){
                                    Text("Negozi per cani")
                                    if ricerca == 0{
                                        Image(systemName: "checkmark")
                                    }
                                }
                                
                                Button(action:{
                                    searchText = "veterinario"
                                    Task {
                                        await MapManager.searchPlaces(
                                            modelContext,
                                            searchText: searchText,
                                            visibleRegion: visibleRegion
                                        )
                                        searchText = ""
                                        ricerca = 1
                                        cameraPosition = .userLocation(fallback: .automatic)
                                    }
                                }){
                                    Text("Veterinari")
                                    if ricerca == 1 {
                                        Image(systemName: "checkmark")
                                    }
                                }
                                if !searchPlacemarks.isEmpty {
                                    
                                    Button(role: .destructive, action: {
                                        MapManager.removeSearchResults(modelContext: modelContext)
                                        ricerca = -1
                                    }, label: {
                                        Text("Rimuovi marker ricerche")
                                        Image(systemName: "mappin.slash.circle.fill")
                                    })
                                }
                            } label: {
                                Image(systemName: "line.3.horizontal.decrease.circle.fill")
                                    .modifier(ColoreDinamicoMenu())
                            }
                        }
                    }
                    .navigationTitle("Mappa")
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
        } else {
            ContentUnavailableView(
            "Connessione Internet assente",
            systemImage: "wifi.exclamationmark",
            description: Text("Connetti il tuo dispositivo alla rete per visualizzare la mappa")
            )
        }
    }
}


