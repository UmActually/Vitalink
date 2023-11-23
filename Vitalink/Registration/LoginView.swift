//
//  LoginView.swift
//  Vitalink
//
//  Created by Marcelo García Pablos Vélez on 17/10/23.
//

import SwiftUI
import PhotosUI

struct LoginView: View {
    @EnvironmentObject var modelData: ModelData
    
    @State private var email: String = "hermenegildo@example.com"
    @State private var password: String = ""
    @State private var alertPresented = false
    @State private var alertText = ""
    @State private var loading = false
    
    var body: some View {
        ZStack {
        VStack(spacing: 40) {
            Text("¡Bienvenido(a) de vuelta!")
                .font(.title)
                .bold()
                .padding(.horizontal)
            
            VStack {
                TextField("Correo", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .frame(height: 50)
                    .background(Color.secondaryButton)
                    .clipShape(.rect(cornerRadius: 8))
                    .padding(.horizontal)
                
                SecureField("Contraseña", text: $password)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .frame(height: 50)
                    .background(Color.secondaryButton)
                    .clipShape(.rect(cornerRadius: 8))
                    .padding(.horizontal)
            }
            .fontDesign(.rounded)
            .font(.title2)
            .foregroundStyle(Color.accentColor)
            
            RegistrationButton(label: "Iniciar Sesión") {
                Task {
                    loading = true
                    let credentials = UserCredentials(email: email, password: password)
                    let result: StringResult = await API.call("token/", method: .post, body: credentials, requiresToken: false)
                    loading = false
                    switch result {
                    case .success(let value):
                        API.shared = .init(bearerToken: value["access"])
                        modelData.tab = .home
                    case .failure(_):
                        alertPresented = true
                    }
                }
            }
        }
            if loading {
                LoadingOverlay(message: "Iniciando sesión...")
                    .frame(maxHeight: .infinity)
            }
        }
        .navigationTitle("Iniciar Sesión")
        .alert(isPresented: $alertPresented) {
            Alert(title: Text("Error"), message: Text(alertText), dismissButton: .default(Text("OK")))
        }
    }
    
    func fieldsAreValid() -> Bool {
        guard !email.isEmpty, !password.isEmpty else {
            alertText = "Favor de completar todos los campos."
            return false
        }
        return true
    }
}

#Preview {
    LoginView()
        .environmentObject(ModelData())
}
