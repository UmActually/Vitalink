//
//  RegistrationView.swift
//  Vitalink
//
//  Created by Marcelo García Pablos Vélez on 17/10/23.
//

import SwiftUI
import PhotosUI

struct RegistrationView: View {
    @EnvironmentObject var modelData: ModelData
    
    @State private var confirmPassword = ""
    @State private var profilePhoto: PhotosPickerItem? = nil
    @State private var alertPresented = false
    @State private var alertText = ""
    @State private var activateNavLink = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationLink(destination: MedicalBackground(), isActive: $activateNavLink) {
                EmptyView()
            }
            
            Form {
                Section(content: {
                    TextField("Nombres", text: $modelData.firstNames)
                        .textInputAutocapitalization(.words)
                    TextField("Apellidos", text: $modelData.lastNames)
                        .textInputAutocapitalization(.words)
                    TextField("Correo electrónico", text: $modelData.email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                    TextField("Teléfono", text: $modelData.phoneNumber)
                        .keyboardType(.phonePad)
                    DatePicker("Fecha de nacimiento", selection: $modelData.birthDate, displayedComponents: .date)
                }, header: {
                    Text("Datos Personales")
                })
                
                Section(content: {
                    SecureField("Contraseña", text: $modelData.password)
                        .textInputAutocapitalization(.never)
                    SecureField("Confirmar contraseña", text: $confirmPassword)
                        .textInputAutocapitalization(.never)
                }, header: {
                    Text("Contraseña")
                })
                
                Section(content: {
                    TextField("Estatura en metros", text: $modelData.height)
                        .keyboardType(.decimalPad)
                }, header: {
                    Text("Datos Biométricos")
                }, footer: {
                    Text("Los datos biométricos son opcionales.")
                })
                
                Section(content: {
                    VStack {
                        PhotosPicker(
                            selection: $profilePhoto,
                            matching: .images,
                            photoLibrary: .shared()) {
                                Text("Agregar Imagen")
                            }
                            .onChange(of: profilePhoto) { newItem in
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                        modelData.profilePhotoData = data
                                    }
                                }
                            }
                        
                        if let photoData = modelData.profilePhotoData,
                           let uiImage = UIImage(data: photoData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, height: 150)
                        } else {
                            Image(systemName: "person.crop.square")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 110)
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }, header: {
                    Text("Foto de Perfil")
                }, footer: {
                    Text("La foto de perfil es opcional. Asegúrate de revisar nuestro aviso de privacidad.")
                })
            }
            .fontDesign(.rounded)
            
            AccentButton(label: "Siguiente", action: {
                if fieldsAreValid() {
                    activateNavLink = true
                } else {
                    alertPresented = true
                }
            })
        }
        .navigationTitle("Registro")
        .alert(isPresented: $alertPresented) {
            Alert(title: Text("Error"), message: Text(alertText), dismissButton: .default(Text("Ok")))
        }
    }
    
    func fieldsAreValid() -> Bool {
        guard !modelData.firstNames.isEmpty, !modelData.lastNames.isEmpty, !modelData.email.isEmpty, !modelData.password.isEmpty, !confirmPassword.isEmpty else {
            alertText = "Favor de completar todos los campos."
            return false
        }
        
        guard modelData.password == confirmPassword else {
            alertText = "Las contraseñas no coinciden."
            return false
        }
        
        // Validar el nombre (solo letras y espacios)
        let nombreCharacterSet = CharacterSet.letters.union(CharacterSet.whitespaces)
        if !CharacterSet(charactersIn: modelData.firstNames).isSubset(of: nombreCharacterSet) {
            alertText = "El nombre debe contener solo letras y espacios."
            return false
        }
        
        // Validar datos numéricos
        let numberCharacterSet = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "."))
        if !CharacterSet(charactersIn: modelData.height).isSubset(of: numberCharacterSet) {
            alertText = "Edad, estatura y peso deben contener solo números."
            return false
        }
        
        return true
    }
}

#Preview {
    RegistrationView()
        .environmentObject(ModelData())
}
