//
//  RegistrationButton.swift
//  Vitalink
//
//  Created by Leonardo Corona Garza on 11/17/23.
//

import SwiftUI

struct RegistrationButton: View {
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(label, action: action)
            .foregroundStyle(Color.white)
            .fontDesign(.rounded)
            .bold()
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.accent)
            .clipShape(.rect(cornerRadius: 8))
            .padding()
    }
}

#Preview {
    RegistrationButton(label: "Hola", action: {
        print("Hola")
    })
}
