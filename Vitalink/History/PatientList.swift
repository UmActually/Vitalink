//
//  PatientList.swift
//  Vitalink
//
//  Created by Leonardo Corona Garza on 11/27/23.
//

import SwiftUI

struct PatientList: View {
    @State private var patients: [MinimalUser]? = nil
    
    var body: some View {
        NavigationView {
            if let patients = patients {
                List(patients) { patient in
                    NavigationLink(destination: HistoryView(patientID: patient.id, patientName: patient.firstNames + " " + patient.lastNames)) {
                        PatientElement(patient: patient)
                    }
                }
                .navigationTitle("Pacientes")
            } else {
                ProgressView("Cargando...")
                    .progressViewStyle(.circular)
                    .navigationTitle("Pacientes")
            }
        }
        .task {
            let result: MinimalUsersResult = await API.call("me/patients/")
            switch result {
            case .success(let value):
                patients = value
            case .failure(_):
                break
            }
        }
    }
}

#Preview {
    PatientList()
}
