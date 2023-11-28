//
//  PatientProfile.swift
//  Vitalink
//
//  Created by Leonardo Corona Garza on 11/22/23.
//

import SwiftUI

struct PatientProfile: View {
    @EnvironmentObject var modelData: ModelData
    @State private var patient: Patient? = nil
    @State private var doctor: GenericUser? = nil
    
    var body: some View {
        NavigationView {
            if let patient = patient, let doctor = doctor {
                List {
                    Section {
                        VStack(alignment: .center) {
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 160)
                                .frame(maxWidth: .infinity)
                                .padding()
                            
                            Text(patient.firstNames + " " + patient.lastNames)
                                .font(.title2)
                                .bold()
                                .foregroundStyle(Color.accentColor)
                            
                            Text("En Vitalink desde \(shortHistoryDateFormatter.string(from: patient.dateJoined))")
                                .font(.caption)
                        }
                    }
                    
                    Section(content: {
                        Text("Email: ") + Text(patient.email).bold()
                        if let phoneNumber = patient.phoneNumber {
                            Text("Teléfono: ") + Text(phoneNumber).bold()
                        }
                        Text("Fecha de nacimiento: ") + Text(historyDateFormatter.string(from: patient.birthDate)).bold()
                    }, header: {
                        Text("Datos Personales")
                    })
                    
                    if let height = patient.height {
                        Section(content: {
                            Text("Estatura: ") + Text(String(format: "%.2f", height)).bold() + Text(" m")
                        }, header: {
                            Text("Datos Biométricos")
                        })
                    }
                    
                    if let history = patient.medicalHistory {
                        Section(content: {
                            Text(history)
                        }, header: {
                            Text("Antecedentes Médicos")
                        })
                    }
                    
                    Section(content: {
                        Text("Dr. / Dra. ") + Text(doctor.firstNames + " " + doctor.lastNames).bold()
                        Text("Email: ") + Text(doctor.email).bold()
                        if let phoneNumber = doctor.phoneNumber {
                            Text("Teléfono: ") + Text(phoneNumber).bold()
                        }
                    }, header: {
                        Text("Doctor")
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
            let patientResult: PatientResult = await API.call("me/")
            switch patientResult {
            case .success(let value):
                patient = value
            case .failure(_):
                break
            }
            
            let doctorResult: GenericUserResult = await API.call("me/doctor/")
            switch doctorResult {
            case .success(let value):
                doctor = value
            case .failure(_):
                break
            }
        }
    }
}

#Preview {
    PatientProfile()
}
