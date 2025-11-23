//
//  RicercaConAI.swift
//  DoggoFinder
//
//  Created by Studente on 08/07/24.
//

import SwiftUI
import Photos

struct RicercaConAI: View {
    
    @ObservedObject var classifier = ImageClassifier()
    
    @State private var isPresenting: Bool = false
    @State private var uiImage: UIImage?
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .camera
    @State private var showPermissionDeniedAlert = false
    @State private var alertMessage = ""
    @State private var isNavigationActive = false
    
    @Binding var searchText: String
    @Binding var selectedFilter: FilterOption
    
    var body: some View {
        
        ScrollView{
            Group {
                if classifier.imageConfidence>0 {
                    HStack{
                        Text("Razza riconosciuta:")
                        Text(classifier.imageClass)
                            .bold()
                        Text("Affidabilità risultato:")
                        if classifier.imageConfidence < 0.5 {
                            Text(String(format: "%.2f%%", classifier.imageConfidence * 100))
                                .foregroundStyle(.red)
                        } else if classifier.imageConfidence < 0.75 {
                            Text(String(format: "%.2f%%", classifier.imageConfidence * 100))
                                .foregroundStyle(.yellow)
                        }else{
                            Text(String(format: "%.2f%%", classifier.imageConfidence * 100))
                                .foregroundStyle(.green)
                        }
                        
                    }
                    HStack{
                        if classifier.imageConfidence < 0.5 {
                            Text("Risultato non affidabile, cambia foto!")
                                .font(.caption)
                                .foregroundStyle(.red)
                        } else if classifier.imageConfidence < 0.75 {
                            Text("Risultato poco affidabile, meglio cambiare foto!")
                                .font(.caption)
                                .foregroundStyle(.yellow)
                        }else {
                            Text("Risultato affidabile!")
                                .font(.caption)
                                .foregroundStyle(.green)
                        }
                    }
                } else {
                    HStack{
                        Text("Scattare/Caricare una foto al/del cane per riconoscerne la razza.")
                            .font(.headline)
                    }
                }
            }
            .padding()
            
            if let image = uiImage{
                Image(uiImage: image)
                    .resizable()
                    .frame(
                        width: UIDevice.current.userInterfaceIdiom == .phone ? 250 : 450,
                        height: UIDevice.current.userInterfaceIdiom == .phone ? 400 : 700
                    )
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 50))
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(Color("color3"), lineWidth: 10)
                    )
            } else {
                RoundedRectangle(cornerRadius: 50)
                    .fill(Color.gray)
                    .frame(
                        width: UIDevice.current.userInterfaceIdiom == .phone ? 200 : 350,
                        height: UIDevice.current.userInterfaceIdiom == .phone ? 350 : 600
                    )
                    .foregroundStyle(.primary)
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(Color("color3"), lineWidth: 10)
                    )
            }
            HStack(spacing: 100){
                VStack{
                    Image(systemName: "camera")
                    Text("Camera")
                        .fontWeight(.bold)
                }
                .onTapGesture {
                    requestCameraPermission{
                        imagePickerSourceType = .camera
                        isPresenting = true
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color("color6"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color("color3"), lineWidth: 5)
                        )
                        .padding(-10)
                )
                VStack{
                    Image(systemName: "photo")
                    Text("Galleria")
                        .fontWeight(.bold)
                }
                .onTapGesture {
                    requestPhotoLibraryPermission{
                        imagePickerSourceType = .photoLibrary
                        isPresenting = true
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color("color6"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color("color3"), lineWidth: 5)
                        )
                        .padding(-10)
                )
            }
            .padding(.top, 50)
        }
        .padding(.top, 50)
        .frame(maxWidth: .infinity)
        .scrollIndicators(.hidden)
        .toolbar{
            if classifier.imageConfidence>0 {
                ToolbarItem(placement: .topBarTrailing){
                    
                    NavigationLink(destination: Bacheca(searchText: classifier.imageClass, selectedFilter: .razza)){
                        Text("Cerca")
                    }
                }
            }
        }
        .sheet(isPresented: $isPresenting){
            ImagePicker(uiImage: $uiImage, isPresenting:  $isPresenting, sourceType: $imagePickerSourceType)
                .onDisappear{
                    if uiImage != nil {
                        classifier.detect(uiImage: uiImage!)
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
