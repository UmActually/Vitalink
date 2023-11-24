//
//  WelcomeView.swift
//  Vitalink
//
//  Created by Leonardo Corona Garza on 11/21/23.
//

import SwiftUI

struct WelcomeView: View {
    @State private var register = false
    @State private var login = false
    
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(destination: RegistrationView(), isActive: $register) {
                    EmptyView()
                }
                
                NavigationLink(destination: LoginView(), isActive: $login) {
                    EmptyView()
                }
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    Image(systemName: "stethoscope")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 120)
                    
                    Text("Vitalink - vinculemos paciente y doctor*.")
                        .fontDesign(.rounded)
                        .font(.title)
                        .bold()
                        .padding(.horizontal)
                    
                    VStack {
                        AccentButton(label: "Registrarme") {
                            register = true
                        }
                        AccentButton(label: "Iniciar sesión", action: {
                            login = true
                        }, secondary: true)
                    }
                    
                    Spacer()
                    
                    (Text("* Vitalink (el \"Software\") es un proyecto sin fines de lucro. Propiedad intelectual, y mantenido por, del Ministerio de Software (MINISO). Consulta nuestra ") + Text("política de privacidad").foregroundStyle(Color.accentColor) + Text(". Hermenegildo Pérez Galaz es un nombre registrado, delegado para su uso en ejemplos y demostraciones por Mango Technologies, Inc., (antes BALLAD)."))
                        .fontDesign(.rounded)
                        .font(.caption)
                        .padding(.horizontal)
                }
            }
        }
    }
}

#Preview {
    WelcomeView()
        .environmentObject(ModelData())
}
