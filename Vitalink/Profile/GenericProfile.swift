//
//  GenericProfile.swift
//  Vitalink
//
//  Created by Leonardo Corona Garza on 11/27/23.
//

import SwiftUI

struct GenericProfile: View {
    let isAdmin: Bool
    
    @EnvironmentObject var modelData: ModelData
    @State private var user: GenericUser? = nil
    
    var body: some View {
        NavigationView {
            if let user = user {
                List {
                    Section {
                        VStack(alignment: .center) {
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 160)
                                .frame(maxWidth: .infinity)
                                .padding()
                            
                            if isAdmin {
                                (Text(user.firstNames + " " + user.lastNames).foregroundStyle(Color.accentColor) + Text(" (Admin)"))
                                    .font(.title2)
                                    .bold()
                            } else {
                                (Text("Dr. / Dra. ") + Text(user.firstNames + " " + user.lastNames).foregroundStyle(Color.accentColor))
                                    .font(.title2)
                                    .bold()
                            }
                            
                            Text("En Vitalink desde \(shortHistoryDateFormatter.string(from: user.dateJoined))\(isAdmin ? " (el inicio de los tiempos)" : "")")
                                .font(.caption)
                        }
                    }
                    
                    Section(content: {
                        Text("Email: ") + Text(user.email).bold()
                        if let phoneNumber = user.phoneNumber {
                            Text("Teléfono: ") + Text(phoneNumber).bold()
                        }
                    }, header: {
                        Text("Datos Personales")
                    })
                    
                    Button("Cerrar Sesión") {
                        API.logout()
                        modelData.tab = .home
                    }
                }
                .fontDesign(.rounded)
                .navigationTitle("Mi Perfil")
            } else {
                ProgressView("Cargando...")
                    .progressViewStyle(.circular)
                    .navigationTitle("Mi Perfil")
            }
        }
        .task {
            let result: GenericUserResult = await API.call("me/")
            switch result {
            case .success(let value):
                user = value
            case .failure(_):
                break
            }
        }
    }
}

#Preview {
    GenericProfile(isAdmin: false)
}
