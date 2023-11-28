//
//  PatientElement.swift
//  Vitalink
//
//  Created by Leonardo Corona Garza on 11/27/23.
//

import SwiftUI

struct PatientElement: View {
    let patient: MinimalUser
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(patient.firstNames + " " + patient.lastNames)
                .font(.headline)
                .foregroundStyle(Color.accentColor)
            Text(patient.email)
                .font(.caption)
            if let phoneNumber = patient.phoneNumber {
                Text(phoneNumber)
                    .font(.caption)
            }
        }
        .fontDesign(.rounded)
    }
}

#Preview {
    PatientElement(patient: MinimalUser(id: 3, email: "hermenegildo@example.com", firstNames: "Hermenegildo", lastNames: "Pérez Galaz", phoneNumber: "81-2340-3432"))
}
