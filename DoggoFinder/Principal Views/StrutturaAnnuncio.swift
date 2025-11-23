//
//  Annuncio.swift
//  DoggoFinder
//
//  Created by Studente on 02/07/24.
//

import SwiftUI

struct StrutturaAnnuncio: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State var annuncio : Annuncio
    @State var modificaAnnuncio: Bool = false
    @State var eliminaAnnuncio: Bool = false
    @State var alert: Bool = false
    @State private var isZoomed = false
    @State private var isPhone = false
    @State var networkMonitor = NetworkMonitor()
    @State var showToolbar: Bool = false
    
    var paginaPrecedente : String
    
    var body: some View {
        NavigationStack {
            ZStack{
                VStack{
                    ScrollView{
                        VStack{
                            HStack{
                                Text(annuncio.razza)
                                    .font(.system(size: 30))
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(.white)
                                    .fontDesign(.monospaced)
                            }
                            .padding(10)
                            .blur(radius: isZoomed ? 10.0 : 0.0)
                            
                            
                            if let immagine = annuncio.immagine {
                                if let imm = immagine.imageFromBase64{
                                    ZStack{
                                        Image(uiImage: imm)
                                            .resizable()
                                            .frame(width: 200, height: 250)
                                            .clipShape(RoundedRectangle(cornerRadius: 20))
                                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color("color3"), lineWidth: 3))
                                            .shadow(radius: 10)
                                    }
                                    .padding(.top, isZoomed ? isPhone ? 100 : 150 : 0)
                                    .frame(maxWidth: .infinity)
                                    .zIndex(1)
                                    .scaleEffect(isZoomed ? isPhone ? 1.5 : 2.5 : 1.0)
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            isZoomed.toggle()
                                        }
                                    }
                                    
                                } else {
                                    Image(systemName: "dog.fill")
                                        .resizable()
                                        .frame(width: 200, height: 250)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color("color3"), lineWidth: 3))
                                        .shadow(radius: 10)
                                }
                            } else {
                                Image(systemName: "dog.fill")
                                    .resizable()
                                    .frame(width: 200, height: 250)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color("color3"), lineWidth: 3))
                                    .shadow(radius: 10)
                                
                            }
                            
                            
                            VStack{
                                if let nome = annuncio.nome {
                                    if !nome.isEmpty {
                                        VStack{
                                            Text ("Nome")
                                                .font(.system(size:20))
                                                .foregroundStyle(Color("color3"))
                                                .fontWeight(.bold)
                                            Text ("\(nome)")
                                                .font(.system(size: 20))
                                                .foregroundStyle(.white)
                                        }
                                        .padding()
                                    }
                                }
                                if !annuncio.proprietario.isEmpty {
                                    VStack{
                                        Text ("Proprietario")
                                            .font(.system(size:20))
                                            .foregroundStyle(Color("color3"))
                                            .fontWeight(.bold)
                                        Text ("\(annuncio.proprietario)")
                                            .font(.system(size: 20))
                                            .foregroundStyle(.white)
                                    }
                                    .padding()
                                }
                                VStack{
                                    Text ("Città di smarrimento")
                                        .font(.system(size:20))
                                        .foregroundStyle(Color("color3"))
                                        .fontWeight(.bold)
                                    Text ("\(annuncio.città), \(annuncio.provincia)")
                                        .font(.system(size: 20))
                                        .foregroundStyle(.white)
                                }
                                .padding()
                                
                                VStack{
                                    Text ("Data di pubblicazione")
                                        .font(.system(size:20))
                                        .foregroundStyle(Color("color3"))
                                        .fontWeight(.bold)
                                    Text ("\(dateToString(data: annuncio.dataPubblicazione))")
                                        .font(.system(size: 20))
                                        .foregroundStyle(.white)
                                }
                                .padding()
                                
                                VStack{
                                    Text ("Recapito telefonico")
                                        .font(.system(size:20))
                                        .foregroundStyle(Color("color3"))
                                        .fontWeight(.bold)
                                    Text ("\(annuncio.telefono)")
                                        .font(.system(size: 20))
                                        .foregroundStyle(.white)
                                }
                                .padding()
                                
                                VStack{
                                    Text ("Email")
                                        .font(.system(size:20))
                                        .foregroundStyle(Color("color3"))
                                        .fontWeight(.bold)
                                    Text ("\(annuncio.email)")
                                        .font(.system(size: 20))
                                        .foregroundStyle(.white)
                                }
                                .padding()
                                
                                if let note = annuncio.note {
                                    if !note.isEmpty{
                                        VStack{
                                            Text ("Note")
                                                .font(.system(size:20))
                                                .foregroundStyle(Color("color3"))
                                                .fontWeight(.bold)
                                            Text ("\(note)")
                                                .font(.system(size: 20))
                                                .foregroundStyle(.white)
                                        }
                                        .padding()
                                    }
                                }
                            }
                            .blur(radius: isZoomed ? 10.0 : 0.0)
                        }
                    }
                    .scrollIndicators(.hidden)
                }
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isZoomed = false
                    }
                }
                .onAppear(){
                    if dataManager.myAnnunci.contains(annuncio) && paginaPrecedente != "Mappa" {
                        showToolbar = true
                    }
                    
                    if UIDevice.current.userInterfaceIdiom == .phone {
                        isPhone = true
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color("color7"))
                .toolbar{
                    
                    if showToolbar{
                        ToolbarItem(placement: .topBarTrailing){
                            Menu{
                                
                                Button(action: {
                                    modificaAnnuncio = true
                                }, label: {
                                    Text("Modifica annuncio")
                                    Image(systemName: "pencil.and.list.clipboard")
                                })
                                
                                Button(role: .destructive, action: {
                                    alert = true
                                }, label: {
                                    Text("Elimina annuncio")
                                    Image(systemName: "trash")
                                })
                                
                            } label: {
                                Image(systemName: "ellipsis.circle.fill")
                                    .modifier(ColoreDinamicoMenu())
                            }
                        }
                    }
                    
                    
                    if paginaPrecedente == "Mappa" {
                        ToolbarItem(placement: .topBarLeading){
                            Button(action: {
                                dismiss()
                            }, label: {
                                Text("Annulla")
                                    .colorMultiply(.black)
                            })
                        }
                    }
                    
                }
                .sheet(isPresented: $modificaAnnuncio){
                    ModificaAnnuncio(annuncio: $annuncio)
                }
                .navigationDestination(isPresented: $eliminaAnnuncio){
                    if paginaPrecedente == "MyAnnunci" {
                        MyAnnunci()
                    } else if paginaPrecedente == "Bacheca"{
                        Bacheca()
                    } else {
                        Mappa()
                    }
                }
                .alert(isPresented: $alert) {
                    Alert(
                        title: Text("Attenzione"),
                        message: networkMonitor.isConnected ? Text("Sei sicuro di voler eliminare l'annuncio?") : Text("Sei sicuro di voler eliminare l'annuncio?\n\nSei in modalità offline,\nl'eliminazione avverrà definitivamente quando tornerai online."),
                        primaryButton: .destructive(Text("Elimina")) {
                            dataManager.deleteAnnuncio(annuncio: annuncio)
                            
                            dataManager.myAnnunci.removeAll(where: {$0.id == annuncio.id})
                            
                            eliminaAnnuncio = true
                            
                        },
                        secondaryButton: .cancel(Text("Annulla"))
                    )
                }
            }
        }
    }
}
