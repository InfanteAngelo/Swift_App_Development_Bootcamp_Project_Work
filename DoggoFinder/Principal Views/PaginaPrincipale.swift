//
//  PaginaPrincipale.swift
//  DoggoFinder
//
//  Created by Studente on 11/07/24.
//

import SwiftUI

struct PaginaPrincipale: View {
    
    @EnvironmentObject var dataManager: DataManager
    
    @State var selection: Int = 0
    
    var body: some View {
        
        VStack{
            TabView(selection: $selection){
                
                Bacheca()
                    .tabItem{
                        Label("Bacheca annunci",systemImage: "list.bullet.clipboard")
                            .accentColor(.primary)
                    }
                    .tag(0)
                Mappa()
                    .tabItem {
                        Label("Mappa", systemImage: "map")
                            .accentColor(.primary)
                    }
                    .tag(1)
                MyAnnunci()
                    .tabItem {
                        Label( "I miei annunci" ,systemImage: "pawprint")
                            .accentColor(.primary)
                    }
                    .tag(2)
            }
            .accentColor(Color("color3"))
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
    }
}
