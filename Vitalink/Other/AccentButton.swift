//
//  RegistrationButton.swift
//  Vitalink
//
//  Created by Leonardo Corona Garza on 11/17/23.
//

import SwiftUI

struct AccentButton: View {
    let label: String
    let action: () -> Void
    let secondary: Bool
    let padding: Bool
    
    init(label: String, action: @escaping () -> Void, secondary: Bool = false, padding: Bool = true) {
        self.label = label
        self.action = action
        self.secondary = secondary
        self.padding = padding
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Rectangle()
                    .foregroundStyle(secondary ? Color.secondaryButton : Color.accentColor)
                    .clipShape(.rect(cornerRadius: 8))
                    .frame(maxWidth: .infinity, maxHeight: 52)
                    .padding(.horizontal, padding ? 16 : 0)
                
                Text(label)
                    .foregroundStyle(secondary ? Color.accentColor : Color.white)
                    .fontDesign(.rounded)
                    .bold()
                    
            }
        }
    }
}

#Preview {
    AccentButton(label: "Hola", action: {
        print("Hola")
    }, secondary: true)
}
