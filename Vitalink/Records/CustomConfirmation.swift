//
//  CustomConfirmation.swift
//  Vitalink
//
//  Created by Leonardo Corona Garza on 11/24/23.
//

import SwiftUI

struct CustomConfirmation: View {
    let search: String
    let cancelAction: () -> Void
    let okAction: () -> Void
    
    @EnvironmentObject var modelData: ModelData
    @State private var loading = false
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
                .opacity(0.2)
            
            ZStack {
                Rectangle()
                    .foregroundStyle(.background)
                    .clipShape(.rect(cornerRadius: 8))
                    
                if !loading {
                    VStack(spacing: 20) {
                        Text("Indicador Personalizado")
                            .font(.headline)
                        Text("Se creará un indicador con el siguiente nombre:")
                            .multilineTextAlignment(.center)
                        TextField(search, text: $modelData.newCustomName)
                            .font(.headline)
                            .foregroundStyle(Color.accentColor)
                            .padding()
                            .background(Color.secondaryButton)
                            .clipShape(.rect(cornerRadius: 8))
                            .padding(.horizontal)
                        HStack {
                            AccentButton(label: "Cancelar", action: cancelAction, secondary: true, padding: false)
                            AccentButton(label: "OK", action: okAction, padding: false)
                        }
                        .padding(.horizontal)
                    }
                    .fontDesign(.rounded)
                } else {
                    ProgressView("Creando...")
                        .progressViewStyle(.circular)
                }
            }
            .frame(width: 300, height: 265)
        }
    }
}

#Preview {
    CustomConfirmation(search: "Dolor de rodilla", cancelAction: {}, okAction: {})
        .environmentObject(ModelData())
}
