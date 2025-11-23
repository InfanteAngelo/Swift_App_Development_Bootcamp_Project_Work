//
//  Account.swift
//  DoggoFinder
//
//  Created by Studente on 02/07/24.
//
 
import SwiftUI
 
struct MyAnnunci: View {
    
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State var ordine: Bool = true
    @State var networkMonitor = NetworkMonitor()
    @State var aggiungiAnnuncio: Bool = false
    @State var accontView: Bool = false
    @State var modificaAnnuncio: Bool = false
    @State var eliminaAnnuncio: Bool = false
    @State var annuncio: Annuncio = Annuncio(razza: "", proprietario: "", città: "", provincia: "", telefono: "", email: "", idProprietario: "")

   var body: some View {
       
       NavigationStack{
           VStack{
               if dataManager.isBusy {
                   ProgressView()
               } else {
                   if dataManager.myAnnunci.isEmpty {
                       Text("Nessun annuncio pubblicato!")
                           .font(.title2)
                           .foregroundStyle(.gray)
                           .padding()
                   }
                   List{
                       ForEach(dataManager.myAnnunci, id: \.id) {
                           annuncio in
                           NavigationLink(destination: StrutturaAnnuncio(annuncio: annuncio, paginaPrecedente: "MyAnnunci")) {
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
                   .onAppear(){
                       
                       ordine = true
                       dataManager.myAnnunci.sort(by: {$0.dataPubblicazione > $1.dataPubblicazione})
           
                   }
                   .sheet(isPresented: $modificaAnnuncio){
                       ModificaAnnuncio(annuncio: $annuncio)
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
                   .toolbar{
                       ToolbarItemGroup(placement: .topBarTrailing){
                           
                           if authViewModel.isOspite {
                               
                               Menu{
                                   
                                   Button(action:{
                                       aggiungiAnnuncio = true
                                   })
                                   {
                                       Text("Inserisci annuncio")
                                       Image(systemName: "plus.circle.fill")
                                           .modifier(ColoreDinamicoMenu())
                                   }
                                   
                                   Button(action: {
                                       
                                       if ordine {
                                           dataManager.myAnnunci.sort(by: {$0.dataPubblicazione < $1.dataPubblicazione})
                                       } else {
                                           dataManager.myAnnunci.sort(by: {$0.dataPubblicazione > $1.dataPubblicazione})
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
                                   
                                   Button(action:{
                                       UserDefaults.standard.setValue(false, forKey: "isOspite")
                                       authViewModel.isOspite = false
                                   }){
                                       Label("Registrati o fai l'accesso", systemImage: "person.fill.badge.plus")
                                   }
                                   
                               } label: {
                                   Image(systemName: "ellipsis.circle.fill")
                                       .modifier(ColoreDinamicoMenu())
                               }
                               
                           } else {
                               
                               Button(action:{
                                   aggiungiAnnuncio = true
                               })
                               {
                                   Image(systemName: "plus.circle.fill")
                                       .modifier(ColoreDinamicoMenu())
                               }
                               
                               Menu{
                                   
                                   Button(action:{
                                       accontView = true
                                   }){
                                       Label("Informazioni utente", systemImage: "info.circle")
                                   }
                                   
                                   Button(action: {
                                       
                                       if ordine {
                                           dataManager.myAnnunci.sort(by: {$0.dataPubblicazione < $1.dataPubblicazione})
                                       } else {
                                           dataManager.myAnnunci.sort(by: {$0.dataPubblicazione > $1.dataPubblicazione})
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
                                   
                                   Button(role: .destructive, action: {
                                       authViewModel.logout()
                                   }, label: {
                                       Text("Logout")
                                       Image(systemName: "rectangle.portrait.and.arrow.right")
                                   })
                                   
                               } label: {
                                   Image(systemName: "person.crop.circle.fill")
                                       .modifier(ColoreDinamicoMenu())
                               }
                           }
                       }
                   }
                   .sheet(isPresented: $aggiungiAnnuncio) {
                       AggiungiAnnuncio()
                   }
                   .sheet(isPresented: $accontView){
                       Account()
                   }
                   .navigationTitle("I miei annunci")
                   .navigationBarTitleDisplayMode(.inline)
                   .listStyle(InsetGroupedListStyle())
                   .scrollIndicators(.hidden)
               }
           }
           .frame(maxWidth: .infinity, maxHeight: .infinity)
       }
    }
}

