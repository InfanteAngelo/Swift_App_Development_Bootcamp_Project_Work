//
//  ModificaAnnuncio.swift
//  DoggoFinder
//
//  Created by Studente on 18/07/24.
//

import SwiftUI
import Photos

struct ModificaAnnuncio: View {
    
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var locationManager = LocationManager()
    @ObservedObject var classifier = ImageClassifier()
    
    @State var nome: String = ""
    @State var immagine: UIImage?
    @State var razza: String = ""
    @State var proprietario: String = ""
    @State var città: String = ""
    @State var provincia: String = ""
    @State var telefono: String = ""
    @State var email: String = ""
    @State var note: String = ""
    @State var latitudine: Double?
    @State var longitudine: Double?
    @State var showImagePicker = false
    @State var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State var showConfirmationDialog = false
    @State var showPermissionDeniedAlert = false
    @State var alertMessage = ""
    @State var showConnectionAlert: Bool = false
    @State var posizioneFornita: Bool = false
    @State var posizioneNonDisponibile: Bool = false
    @State var networkMonitor = NetworkMonitor()
    @State private var razzaVuoto: String?
    @State private var cittàVuoto: String?
    @State private var provinciaVuoto: String?
    @State private var telefonoVuoto: String?
    @State private var emailVuoto: String?
    @State private var emailNonValida: String?
    @State private var lunghezzaPrecedente: Int = 0
    @State private var numeroDiTelefonoNonValido: String?
    
    @Binding var annuncio: Annuncio
    
    var body: some View {
        NavigationStack{
            Form{
                Section(header: Text("Carica foto")){
                    HStack{
                        Spacer()
                        if let immagine = immagine{
                            Image(uiImage: immagine)
                                .resizable()
                                .frame(width: 120, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color("color3"), lineWidth: 4)
                                )
                        } else{
                            Image(systemName: "photo.on.rectangle.angled")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 100)
                                .clipShape(Rectangle())
                                .opacity(0.4)
                        }
                        Spacer()
                    }
                }
                .padding(.vertical, 20)
                .onTapGesture{
                    showConfirmationDialog = true
                }
                
                Section(header: Text("Geolocalizzazione")){
                    HStack{
                        Button(action:{
                            
                            if posizioneFornita {
                                latitudine = nil
                                longitudine = nil
                                posizioneFornita = false
                                posizioneNonDisponibile = false
                            } else {
                                
                                locationManager.checkLocationAuthorization()
                                
                                if locationManager.permission == "restricted" || locationManager.permission == "denied" {
                                    alertMessage = "L'accesso alla posizione è stato negato. Per favore, abilitalo nelle impostazioni per un miglior utilizzo della mappa."
                                    showPermissionDeniedAlert = true
                                } else {
                                    if let coordinate = locationManager.lastKnownLocation {
                                        latitudine = coordinate.latitude
                                        longitudine = coordinate.longitude
                                        
                                        locationManager.getCityAndProvince(latitude: coordinate.latitude, longitude: coordinate.longitude){
                                            città, provincia in
                                            self.città = città ?? ""
                                            self.provincia = provincia ?? ""
                                        }
                                        posizioneFornita = true
                                        posizioneNonDisponibile = false
                                    } else {
                                        posizioneFornita = false
                                        posizioneNonDisponibile = true
                                    }
                                }
                            }
                            
                        }){
                            Text(posizioneFornita ? "Rimuovi\nposizione" : "Aggiungi\nposizione")
                                .multilineTextAlignment(.center)
                                .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.gray)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(Color(colorScheme == .dark ? Color.white : Color.black), lineWidth: 2)
                                )
                                .padding(-10)
                        )
                        .padding(.vertical, 20)
                        Spacer()
                        Text(posizioneFornita ? "Posizione fornita con successo" :
                                posizioneNonDisponibile ? "Posizione non disponibile" : "Posizione non fornita")
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    .padding(.leading)
                    
                }
                
                Section(header: Text("Informazioni animale")){
                    HStack{
                        VStack (alignment: .leading) {
                            Text("Nome")
                            TextField("es: Pluto", text: $nome)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .disableAutocorrection(true)
                        }
                        VStack (alignment: .leading){
                            Text("Razza*")
                            TextField("es: Beagle", text: $razza)
                                .autocorrectionDisabled(true)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            if razzaVuoto != nil {
                                Text("Campo obbligatorio")
                                    .foregroundStyle(.red)
                                    .font(.caption)
                                    .bold()
                            }
                        }
                    }
                    VStack (alignment: .leading){
                        Text("Proprietario")
                        TextField("es: Vincenzo", text: $proprietario)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                    }
                }
                Section(header: Text("Dove lo hai smarrito?")){
                    HStack{
                        VStack (alignment: .leading){
                            Text("Città*")
                            TextField("es: Mercogliano", text: $città)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .disableAutocorrection(true)
                            if cittàVuoto != nil {
                                Text("Campo obbligatorio")
                                    .foregroundStyle(.red)
                                    .font(.caption)
                                    .bold()
                            }
                        }
                        VStack (alignment: .leading) {
                            Text("Provincia*")
                            TextField("es: Avellino", text: $provincia)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .disableAutocorrection(true)
                            if provinciaVuoto != nil {
                                Text("Campo obbligatorio")
                                    .foregroundStyle(.red)
                                    .font(.caption)
                                    .bold()
                            }
                        }
                    }
                }
                Section(header: Text("Recapiti")){
                    VStack (alignment: .leading){
                        Text("Numero di telefono*")
                        TextField("es: 3926091965", text: $telefono)
                            .autocorrectionDisabled(true)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onAppear(){
                                lunghezzaPrecedente = telefono.count
                            }
                            .onChange(of: telefono){
                                if  telefono.count > lunghezzaPrecedente && telefono.count == 3 {
                                    telefono.append(" ")
                                }
                                if telefono.count > lunghezzaPrecedente && telefono.count == 7 {
                                    telefono.append(" ")
                                }
                                
                                lunghezzaPrecedente = telefono.count
                            }
                        if telefonoVuoto != nil {
                            Text("Campo obbligatorio")
                                .foregroundStyle(.red)
                                .font(.caption)
                                .bold()
                        }
                        if let numeroDiTelefonoNonValido = numeroDiTelefonoNonValido {
                            Text(numeroDiTelefonoNonValido)
                                .foregroundStyle(Color(.red))
                                .bold()
                                .font(.caption)
                        }
                        Text("Email*")
                        let placeHolderEmail = "es: lollo.ianto@icloud.com"
                        TextField(placeHolderEmail, text: $email)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        if emailVuoto != nil {
                            Text("Campo obbligatorio")
                                .foregroundStyle(.red)
                                .font(.caption)
                                .bold()
                        }
                        if let emailNonValida = emailNonValida{
                            Text(emailNonValida)
                                .foregroundStyle(.red)
                                .font(.caption)
                                .bold()
                        }
                    }
                        
                }
                Section(header: Text("Informazioni aggiuntive")){
                    VStack (alignment: .leading) {
                        Text("Note")
                        TextField("es: Pluto ha una macchia bianchia sulla zampa destra anteriore", text: $note)
                            .autocorrectionDisabled(true)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                Text("* campo obbligatorio")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .onAppear(){
                nome = annuncio.nome ?? ""
                immagine = annuncio.immagine?.imageFromBase64
                razza = annuncio.razza
                proprietario = annuncio.proprietario
                città = annuncio.città
                provincia = annuncio.provincia
                telefono = annuncio.telefono
                email = annuncio.email
                note = annuncio.note ?? ""
                latitudine = annuncio.latitudine
                longitudine = annuncio.longitudine
                
                if latitudine != nil && longitudine != nil {
                    posizioneFornita = true
                }
            }
            .confirmationDialog("Scegli un'opzione", isPresented: $showConfirmationDialog){
                confirmationDialogButtons()
            }
            .sheet(isPresented: $showImagePicker){
                ImagePicker(uiImage: $immagine, isPresenting: $showImagePicker, sourceType: $imagePickerSourceType)
                    .onDisappear{
                        if immagine != nil {
                            classifier.detect(uiImage: immagine!)
                            razza = classifier.imageClass
                        }
                    }
            }
            .alert(isPresented: $showPermissionDeniedAlert) {
                Alert(
                    title: Text("Permesso Negato"),
                    message: Text(alertMessage),
                    primaryButton: .default(Text("Vai a Impostazioni")) {
                        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(appSettings)
                        }
                    },
                    secondaryButton: .cancel(Text("Annulla"))
                )
            }
            .alert(isPresented: $showConnectionAlert){
                Alert(
                    title: Text("Sei in modalità offline"),
                    message: Text("Le modifiche saranno visibili agli altri utenti appena tornerai online."),
                    primaryButton: .default(Text("Salva")) {
                        validazioneForm()
                    },
                    secondaryButton: .cancel(Text("Annulla"))
                )
            }
            .navigationBarTitle("Modifica annuncio",displayMode: .inline)
            .navigationBarItems(trailing:Button("Salva"){
                if networkMonitor.isConnected {
                    validazioneForm()
                } else {
                    showConnectionAlert = true
                }
            })
            .navigationBarItems(leading: Button("Annulla"){
                presentationMode.wrappedValue.dismiss()
            })
            .navigationBarBackButtonHidden()
        }
    }
    
    private func confirmationDialogButtons() -> some View {
        Group{
            Button("Carica foto"){
                requestPhotoLibraryPermission {
                    imagePickerSourceType = .photoLibrary
                    showImagePicker = true
                }
            }
            if immagine != nil {
                Button("Rimuovi foto", role: .destructive){
                    immagine = nil
                }
            }
            Button("Annulla", role: .cancel){}
        }
    }
    
    private func requestPhotoLibraryPermission(completion: @escaping () -> Void) {
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .authorized, .limited:
                completion()
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { newStatus in
                    if newStatus == .authorized {
                        DispatchQueue.main.async {
                            completion()
                        }
                    }
                }
            case .denied, .restricted:
                DispatchQueue.main.async {
                    alertMessage = "L'accesso alla galleria è stato negato. Per favore, abilitalo nelle impostazioni."
                    showPermissionDeniedAlert = true
                }
            @unknown default:
                break
            }
        }
    
    private func validazioneForm() {
        
        razzaVuoto = razza.isEmpty ? "La razza è obbligatoria" : nil
        cittàVuoto = città.isEmpty ? "La città è obbligatoria" : nil
        provinciaVuoto = provincia.isEmpty ? "La provincia è obbligatoria" : nil
        telefonoVuoto = telefono.isEmpty ? "Il numero di telefono è obbligatorio" : nil
        emailVuoto = email.isEmpty ? "L'email è obbligatoria" : nil
        
        if !email.isEmpty{
            emailNonValida = !validateEmail(email: email) ? "Email inserita non valida." : nil
        } else {
            emailNonValida = nil
        }
        
        if !telefono.isEmpty{
            numeroDiTelefonoNonValido = !validatePhoneNumber(telefono: telefono) ? "Numero di telefono inserito non valido." : nil
        } else {
            numeroDiTelefonoNonValido = nil
        }
        
        if razzaVuoto == nil && cittàVuoto == nil && provinciaVuoto == nil && telefonoVuoto == nil && emailVuoto == nil && emailNonValida == nil && numeroDiTelefonoNonValido == nil{

            let dict = dataManager.infoUtente
            let idUtente = dict["id"] ?? ""
                
            let newAnnuncio = Annuncio(id: annuncio.id,nome: nome.isEmpty ? nil : nome, immagine: immagine?.base64, razza: razza, proprietario: proprietario, città: città, provincia: provincia, telefono: telefono, email: email, idProprietario: idUtente, note: note.isEmpty ? nil : note, latitudine: latitudine, longitudine: longitudine, dataPubblicazione: annuncio.dataPubblicazione)
            
            dataManager.addAnnuncio(annuncio: newAnnuncio)
            
            if let index = dataManager.myAnnunci.firstIndex(where: {$0.id == newAnnuncio.id}){
                dataManager.myAnnunci[index] = newAnnuncio
            } else {
                dataManager.myAnnunci.append(newAnnuncio)
            }
            
            annuncio = newAnnuncio
            presentationMode.wrappedValue.dismiss()
        }
    }
}

