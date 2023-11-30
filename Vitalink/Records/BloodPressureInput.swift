//
//  BloodPressureInput.swift
//  Vitalink
//
//  Created by Leonardo Corona Garza on 11/30/23.
//

import SwiftUI

struct BloodPressureInput: View {
    let index: Int
    
    @EnvironmentObject var modelData: ModelData

    var body: some View {
        VStack {
            Text("Sistólica")
                .fontDesign(.rounded)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)
            
            HStack {
                TextField("", value: $modelData.recordInputs[index].value, format: .number)
                    .keyboardType(.decimalPad)
                    .font(.title2)
                    .foregroundStyle(Color.accentColor)
                    .padding()
                    .frame(width: 100)
                    .background(Color.secondaryButton)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                Text("mmHg")
                    .font(.title2)
                    .bold()
            }
            .frame(maxWidth: .infinity)
            
            Text("Diastólica")
                .fontDesign(.rounded)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)
            
            HStack {
                TextField("", value: $modelData.recordInputs[index].altValue, format: .number)
                    .keyboardType(.decimalPad)
                    .font(.title2)
                    .foregroundStyle(Color.accentColor)
                    .padding()
                    .frame(width: 100)
                    .background(Color.secondaryButton)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                Text("mmHg")
                    .font(.title2)
                    .bold()
            }
            .frame(maxWidth: .infinity)
        }
        .fontDesign(.rounded)
    }
}

#Preview {
    BloodPressureInput(index: 0)
        .environmentObject(ModelData())
}
