//
//  Account.swift
//  DoggoFinder
//
//  Created by Studente on 09/07/24.
//

import SwiftUI
import Photos

struct Account: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var dataManager: DataManager
    
    @State var showImagePicker = false
    @State var showConfirmationDialog = false
    @State var selectedImage: UIImage?
    @State var selectedImageBase64: String?
    @State var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State var showPermissionDeniedAlert = false
    @State var alertMessage = ""
    @State var showAnnunci: Bool = false
    @State var showInfo: Bool = false
    @State var modificaInfo: Bool = false
    @State var nome: String = ""
    @State var cognome: String = ""
    @State var email: String = ""
    @State var numeroDiTelefono: String = ""
    @State var idUtente: String = ""
    @State var logout: Bool = false
    
    var body: some View {
            
        NavigationStack{
            VStack{
                
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 10)
                        .onTapGesture {
                            showConfirmationDialog = true
                        }
                } else {
                    Image(systemName: "person.crop.circle.fill.badge.plus")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .shadow(radius: 10)
                        .onTapGesture {
                            showConfirmationDialog = true
                        }
                }
                VStack{
                    Group {
                        
                        if nome.isEmpty {
                            Text("Nome non fornito")
                                .font(.system(size:20))
                                .foregroundStyle(Color("color9"))
                                .fontWeight(.bold)
                                .padding()
                        } else {
                            VStack{
                                Text("Nome:")
                                    .font(.system(size:20))
                                    .foregroundStyle(Color.black)
                                    .fontWeight(.bold)
                                Text(nome)
                                    .foregroundStyle(Color.white)
                                    .font(.system(size:20))
                            }
                            .padding()
                        }
                        
                        
                        if cognome.isEmpty {
                            Text("Cognome non fornito")
                                .foregroundStyle(Color("color9"))
                                .font(.system(size:20))
                                .fontWeight(.bold)
                                .padding()
                        } else {
                            VStack{
                                Text("Cognome:")
                                    .foregroundStyle(Color.black)
                                    .font(.system(size:20))
                                    .fontWeight(.bold)
                                Text(cognome)
                                    .foregroundStyle(Color.white)
                                    .font(.system(size:20))
                            }
                            .padding()
                        }
                        
                        
                        if email.isEmpty {
                            Text("Email di registrazione non fornita")
                                .foregroundStyle(Color("color9"))
                                .font(.system(size:20))
                                .fontWeight(.bold)
                                .padding()
                        } else {
                            VStack{
                                Text("Email:")
                                    .foregroundStyle(Color.black)
                                    .font(.system(size:20))
                                    .fontWeight(.bold)
                                Text(email)
                                    .foregroundStyle(Color.white)
                                    .font(.system(size:20))
                            }
                            .padding()
                        }
                        
                        
                        
                        if numeroDiTelefono.isEmpty {
                            Text("Telefono non fornito")
                                .font(.system(size:20))
                                .foregroundStyle(Color("color9"))
                                .fontWeight(.bold)
                                .padding()
                        } else {
                            VStack{
                                Text("Telefono:")
                                    .foregroundStyle(Color.black)
                                    .font(.system(size:20))
                                    .fontWeight(.bold)
                                Text(numeroDiTelefono)
                                    .foregroundStyle(Color.white)
                                    .font(.system(size:20))
                            }
                            .padding()
                        }
                        
                        
                        Button(action: {
                            modificaInfo = true
                        }){
                            Text("Modifica")
                                .fontWeight(.bold)
                                .foregroundStyle(Color.black)
                                .frame(height: 58)
                                .frame(minWidth: 0, maxWidth: 100)
                                .background(Color("color9"))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.black, lineWidth: 5)
                                )
                                .cornerRadius(15)
                        }
                    }
                }
                .padding(.top)
                
            }
            .onAppear(){
                
                let dict = dataManager.infoUtente
                idUtente = dict["id"] ?? ""
                email = dict["email"] ?? ""
                nome = dict["nome"] ?? ""
                cognome = dict["cognome"] ?? ""
                numeroDiTelefono = dict["telefono"] ?? ""
                selectedImageBase64 = dict["immagine"] ?? nil
                
                if let selectedImageBase64 = selectedImageBase64 {
                    selectedImage = selectedImageBase64.imageFromBase64
                }
            }
            .onChange(of: selectedImage){
                if let selectedImage = selectedImage {
                    
                    let utente = Utente(id: UUID(uuidString: idUtente)!, nome: nome, immagine: selectedImage.base64 ?? "", cognome: cognome, email: email, telefono: numeroDiTelefono)
                    
                    dataManager.addInfoUtenteRegistrazione(utente: utente)
                }
            }
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Button(action:{
                        presentationMode.wrappedValue.dismiss()
                    })
                    {
                        Text("Fine")
                            .colorMultiply(.black)
                    }
                }
            }
            .confirmationDialog("Scegli un'opzione", isPresented: $showConfirmationDialog){
                confirmationDialogButtons()
            }
            .sheet(isPresented: $showImagePicker){
                ImagePicker(uiImage: $selectedImage, isPresenting: $showImagePicker, sourceType: $imagePickerSourceType)
            }
            .sheet(isPresented: $modificaInfo){
                ModificaInfo(immagine: selectedImageBase64, email: email, nome: $nome, cognome: $cognome, numeroDiTelefono: $numeroDiTelefono)
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
               Color("color5")
            )
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    private func confirmationDialogButtons() -> some View {
        Group{
            Button("Scatta foto"){
                requestCameraPermission {
                    imagePickerSourceType = .camera
                    showImagePicker = true
                }
            }
            Button("Carica foto"){
                requestPhotoLibraryPermission {
                    imagePickerSourceType = .photoLibrary
                    showImagePicker = true
                }
            }
            if selectedImage != nil {
                Button("Rimuovi foto", role: .destructive){
                    selectedImage = nil
                    let dict = dataManager.infoUtente
                    let idUtente = dict["id"] ?? ""
                    
                    let utente = Utente(id: UUID(uuidString: idUtente)!, nome: nome, immagine: "", cognome: cognome, email: email, telefono: numeroDiTelefono)
                    dataManager.addInfoUtenteRegistrazione(utente: utente)
                }
            }
            Button("Annulla", role: .cancel){}
        }
    }
    
    private func requestCameraPermission(completion: @escaping () -> Void) {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                completion()
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        DispatchQueue.main.async {
                            completion()
                        }
                    }
                }
            case .denied, .restricted:
                DispatchQueue.main.async {
                    alertMessage = "L'accesso alla fotocamera è stato negato. Per favore, abilitalo nelle impostazioni."
                    showPermissionDeniedAlert = true
                }
            @unknown default:
                break
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
}

