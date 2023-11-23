//
//  MedicalBackground.swift
//  Vitalink
//
//  Created by Marcelo García Pablos Vélez on 29/10/23.
//

import SwiftUI

struct MedicalBackground: View {
    @EnvironmentObject var modelData: ModelData
    
    @State private var personalBackground = ""
    @State private var familyBackground = ""
    @State private var loading = false
    @State private var registrationFailure = true
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Form {
                Section(content: {
                    VStack(spacing: 15) {
                        Text("Antecedentes Personales")
                            .fontDesign(.rounded)
                            .font(.headline)
                        TextEditor(text: $personalBackground)
                            .fontDesign(.rounded)
                            .frame(height: 200)
                            .clipShape(.rect(cornerRadius: 8))
                        
                        Divider()
                        
                        Text("Antecedentes Familiares")
                            .fontDesign(.rounded)
                            .font(.headline)
                        TextEditor(text: $familyBackground)
                            .frame(height: 200)
                            .clipShape(.rect(cornerRadius: 8))
                    }
                    .padding()
                    .cornerRadius(12)
                }, header: {
                    Text("Antecedentes")
                })
            }
            
            RegistrationButton(label: "Registrarme", action: {
                modelData.medicalHistory = "Antecedentes Personales:\n\(personalBackground)\n\nAntecedentes Familiares:\n\(familyBackground)"
                
                Task {
                    loading = true
                    print("Registering user...")
                    let result = await modelData.registerUser()
                    loading = false
                    print("Parsing result...")
                    switch result {
                    case .success(let value):
                        // Reemplazar el objeto de API() por uno con token.
                        API.shared = .init(bearerToken: value.token)
                        modelData.tab = .home
                        try! await Task.sleep(nanoseconds: 750_000_000)
                        modelData.registrationSuccess = true
                    case .failure(_):
                        registrationFailure = true
                    }
                }
            })
            
            if loading {
                LoadingOverlay(message: "Completando registro...")
                    .frame(maxHeight: .infinity)
            }
        }
        .navigationTitle("Registro del Usuario")
        .alert(isPresented: $registrationFailure) {
            Alert(title: Text("Error"), message: Text("Hubo un error en el registro. Favor de intentar más tarde."), dismissButton: .default(Text("OK")))
        }
    }
}



#Preview {
    MedicalBackground()
        .environmentObject(ModelData())
}
