//
//  Bacheca.swift
//  DoggoFinder
//
//  Created by Studente on 27/06/24.
//

import SwiftUI

struct Bacheca: View {
    
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State var networkMonitor = NetworkMonitor()
    @State var searchText: String = ""
    @State var selectedFilter: FilterOption = .città
    @State var buttonCancelActive: Bool = false
    @State var aggiungiAnnuncio: Bool = false
    @State var showAlert: Bool = false
    @State var modificaAnnuncio: Bool = false
    @State var eliminaAnnuncio: Bool = false
    @State var annuncio: Annuncio = Annuncio(razza: "", proprietario: "", città: "", provincia: "", telefono: "", email: "", idProprietario: "")
    @State var ordine: Bool = true
    
    var filteredAnnunci: [Annuncio] {
            if searchText.isEmpty{
                return dataManager.annunci
            }else{
                return dataManager.annunci.filter {
                    filtro(item: $0, filtro: selectedFilter)
                }
            }
        }
    
    var body: some View {
        
        NavigationStack{
            
            VStack{
                
                if dataManager.isBusy {
                    
                    ProgressView()
                    
                } else {
                    
                    HStack{
                        SearchBar(text: $searchText, buttonCancelButton: $buttonCancelActive)
                        if buttonCancelActive {
                            Button(action: {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                buttonCancelActive = false
                            }, label: {
                                Image(systemName: "keyboard.chevron.compact.down")
                            })
                            .padding()
                            .overlay(
                                Divider()
                                    .overlay(
                                        Color("color10").opacity(0.6)
                                    )
                                    .padding(.trailing, 20)
                                , alignment: .leading
                            )
                        }
                    }
                    
                    Picker("Opzioni di ricerca", selection: $selectedFilter) {
                        ForEach(FilterOption.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    .padding(10)
                    .frame(maxWidth: 250)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("color3"), lineWidth: 2)
                    )
                    .padding(.vertical)
                    
                    if !networkMonitor.isConnected {
                        VStack{
                            Text("Sei in modalità offline")
                                .foregroundStyle(Color("color3"))
                                .bold()
                                .padding()
                            if let data = UserDefaults.standard.string(forKey: "dataAggiornamento"), let ora = UserDefaults.standard.string(forKey: "oraAggiornamento"){
                                Text("Ultimo aggiornamento avvenuto il \(data) alle ore \(ora)")
                                    .padding(.horizontal)
                                    .padding(.bottom)
                            } else {
                                Text("Ultimo aggiornamento non disponibile")
                                    .padding(.horizontal)
                                    .padding(.bottom)
                            }
                        }
                        .background(Color.gray)
                        .cornerRadius(10)
                        .padding(.vertical)
                    }
                    
                    if filteredAnnunci.isEmpty{
                        Text("Nessun annuncio trovato!")
                            .padding()
                    }
                    
                    Group {
                        List{
                            ForEach(dataManager.annunci, id: \.id){
                                annuncio in
                                if self.filtro(item: annuncio, filtro: selectedFilter){
                                    NavigationLink(destination: StrutturaAnnuncio(annuncio: annuncio, paginaPrecedente: "Bacheca")){
                                        HStack{
                                            Spacer()
                                            if let immagine = annuncio.immagine{
                                                if let imm = immagine.imageFromBase64 {
                                                    Image(uiImage: imm)
                                                        .resizable()
                                                        .frame(
                                                            width: UIDevice.current.userInterfaceIdiom == .phone ? 100 : 200,
                                                            height: UIDevice.current.userInterfaceIdiom == .phone ? 150 : 300
                                                        )
                                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 25)
                                                                .stroke(Color.gray, lineWidth: 4)
                                                        )
                                                        .listRowSeparator(.hidden)
                                                        .padding(.top)
                                                } else {
                                                    Image(systemName: "dog.fill")
                                                        .resizable()
                                                        .frame(
                                                            width: UIDevice.current.userInterfaceIdiom == .phone ? 100 : 200,
                                                            height: UIDevice.current.userInterfaceIdiom == .phone ? 150 : 300
                                                        )
                                                        .clipped()
                                                        .listRowSeparator(.hidden)
                                                        .padding(.top)
                                                }
                                            } else { 
                                                Image(systemName: "dog.fill")
                                                    .resizable()
                                                    .frame(
                                                        width: UIDevice.current.userInterfaceIdiom == .phone ? 100 : 200,
                                                        height: UIDevice.current.userInterfaceIdiom == .phone ? 150 : 300
                                                    )
                                                    .clipped()
                                                    .cornerRadius(10)
                                                    .listRowSeparator(.hidden)
                                                    .padding(.top)
                                            }
                                            Spacer()
                                            VStack (alignment: .leading, spacing: 10){
                                                
                                                if dataManager.myAnnunci.contains(annuncio){
                                                    Text("Questo annuncio è tuo!")
                                                        .listRowSeparator(.hidden)
                                                        .fontWeight(.bold)
                                                        .foregroundStyle(Color("color3"))
                                                        .multilineTextAlignment(.center)
                                                }
                                                
                                                if let nome = annuncio.nome{
                                                    if !nome.isEmpty{
                                                        HStack{
                                                            Text("Nome: ")
                                                                .fontWeight(.bold)
                                                            Text(nome)
                                                        }
                                                        .listRowSeparator(.hidden)
                                                    }
                                                }
                                                HStack{
                                                    Text("Razza: ")
                                                        .fontWeight(.bold)
                                                    Text(annuncio.razza)
                                                }
                                                .listRowSeparator(.hidden)
                                                
                                                HStack{
                                                    Text("Città: ")
                                                        .fontWeight(.bold)
                                                    Text(annuncio.città)
                                                }
                                                .listRowSeparator(.hidden)
                                                
                                                HStack{
                                                    Text("Data: ")
                                                        .fontWeight(.bold)
                                                    Text(dateToString(data: annuncio.dataPubblicazione))
                                                }
                                                .listRowSeparator(.hidden)
                                            }
                                            Spacer()
                                        }
                                        .swipeActions(edge: .leading){
                                            
                                            if dataManager.myAnnunci.contains(annuncio){
                                                Button{
                                                    self.annuncio = annuncio
                                                    modificaAnnuncio = true
                                                } label: {
                                                    Text("Modifica")
                                                    Image(systemName: "pencil.and.list.clipboard")
                                                }
                                                .tint(.yellow)
                                            }
                                        }
                                        .swipeActions(edge: .trailing){
                                            if dataManager.myAnnunci.contains(annuncio){
                                                Button(role: .destructive){
                                                    self.annuncio = annuncio
                                                    eliminaAnnuncio = true
                                                } label: {
                                                    Text("Elimina")
                                                    Image(systemName: "trash")
                                                }
                                            }
                                        }
                                    }
                                    Divider()
                                        .frame(height: 2)
                                        .background(Color("color3"))
                                        .padding(.horizontal, 3)
                                        .listRowSeparator(.hidden)
                                }
                            }
                        }
                        .onAppear(){
                            
                            ordine = true
                            dataManager.annunci.sort(by: {$0.dataPubblicazione > $1.dataPubblicazione})
                
                        }
                        .refreshable {
                            if networkMonitor.isConnected {
                                dataManager.fetchAnnunci()
                            } else {
                                showAlert = true
                            }
                        }
                        .sheet(isPresented: $modificaAnnuncio){
                            ModificaAnnuncio(annuncio: $annuncio)
                        }
                        .alert(isPresented: $showAlert){
                            Alert(
                                title: Text("Sei in modalità offline"),
                                message: Text("Per aggiornare la bacheca devi essere online."),
                                primaryButton: .default(Text("Vai a Impostazioni")) {
                                    if let url = URL(string: "App-Prefs:root=WIFI") {
                                        if UIApplication.shared.canOpenURL(url) {
                                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                        } else {
                                            if let url = URL(string: "App-Prefs:root") {
                                                UIApplication.shared.open(url)
                                            }
                                        }
                                    }
                                },
                                secondaryButton: .cancel(Text("Annulla"))
                            )
                        }
                        .alert(isPresented: $eliminaAnnuncio) {
                            Alert(
                                title: Text("Attenzione"),
                                message: networkMonitor.isConnected ? Text("Sei sicuro di voler eliminare l'annuncio?") : Text("Sei sicuro di voler eliminare l'annuncio?\n\nSei in modalità offline,\nl'eliminazione avverrà definitivamente quando tornerai online."),
                                primaryButton: .destructive(Text("Elimina")) {
                                    
                                    dataManager.deleteAnnuncio(annuncio: annuncio)
                                    
                                    dataManager.myAnnunci.removeAll(where: {$0.id == annuncio.id})
                                    
                                },
                                secondaryButton: .cancel(Text("Annulla"))
                            )
                        }
                        .navigationBarBackButtonHidden()
                        .toolbar{
                            ToolbarItemGroup(placement: .topBarTrailing){
                                
                                Button(action: {
                                    if networkMonitor.isConnected {
                                        dataManager.fetchAnnunci()
                                    } else {
                                        showAlert = true
                                    }
                                })
                                {
                                    Image(systemName: "arrow.clockwise.circle.fill")
                                        .modifier(ColoreDinamicoMenu())
                                }
                                
                                Menu{
                                    Button(action:{
                                        aggiungiAnnuncio = true
                                    })
                                    {
                                        Label("Inserisci annuncio", systemImage: "square.and.pencil")
                                    }
                                    NavigationLink(destination: RicercaConAI(searchText: $searchText, selectedFilter: $selectedFilter)){
                                        Label("Cerca annuncio con foto", systemImage: "magnifyingglass")
                                    }
                                    
                                    Button(action: {
                                        
                                        if ordine {
                                            dataManager.annunci.sort(by: {$0.dataPubblicazione < $1.dataPubblicazione})
                                        } else {
                                            dataManager.annunci.sort(by: {$0.dataPubblicazione > $1.dataPubblicazione})
                                        }
                                        
                                        ordine.toggle()
                                        
                                    }, label: {
                                        
                                        if ordine {
                                            Text("Mostra dai meno recenti")
                                            Image(systemName: "arrow.down")
                                        } else {
                                            Text("Mostra dai più recenti")
                                            Image(systemName: "arrow.up")
                                        }
                                        
                                    })
                                } label: {
                                    Image(systemName: "ellipsis.circle.fill")
                                        .modifier(ColoreDinamicoMenu())
                                }
                            }
                        }
                        .listStyle(InsetGroupedListStyle())
                        .scrollIndicators(.hidden)
                        .sheet(isPresented: $aggiungiAnnuncio) {
                            AggiungiAnnuncio()
                        }
                    }
                }
            }
            .navigationTitle("Bacheca")
            .navigationBarTitleDisplayMode(.inline)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    func filtro(item: Annuncio, filtro: FilterOption) -> Bool {
        switch filtro {
        case FilterOption.città:
            if searchText.isEmpty {
                return true
            } else {
                return item.città.localizedLowercase.hasPrefix(searchText.lowercased())
            }
        case FilterOption.razza:
            if searchText.isEmpty {
                return true
            } else {
                return item.razza.localizedLowercase.hasPrefix(searchText.lowercased())
            }
        }
    }
}

