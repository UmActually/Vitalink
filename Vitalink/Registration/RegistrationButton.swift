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
    let secondary: Bool
    
    init(label: String, action: @escaping () -> Void, secondary: Bool = false) {
        self.label = label
        self.action = action
        self.secondary = secondary
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Rectangle()
                    .foregroundStyle(secondary ? Color.secondaryButton : Color.accentColor)
                    .clipShape(.rect(cornerRadius: 8))
                    .frame(maxWidth: .infinity, maxHeight: 52)
                    .padding(.horizontal)
                
                Text(label)
                    .foregroundStyle(secondary ? Color.accentColor : Color.white)
                    .fontDesign(.rounded)
                    .bold()
                    
            }
        }
    }
}

#Preview {
    RegistrationButton(label: "Hola", action: {
        print("Hola")
    }, secondary: true)
}
