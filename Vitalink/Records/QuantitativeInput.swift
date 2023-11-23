//
//  QuantitativeInput.swift
//  Vitalink
//
//  Created by Leonardo Corona Garza on 11/22/23.
//

import SwiftUI

struct QuantitativeInput: View {
    let index: Int
    
    @EnvironmentObject var modelData: ModelData

    var indicator: HealthIndicator {
        modelData.recordInputs[index].healthIndicator
    }
    
    var body: some View {
        VStack {
            Text("Valor o intensidad")
                .fontDesign(.rounded)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)
            
            HStack {
                TextField("", value: $modelData.recordInputs[index].value, format: .number)
                    .keyboardType(indicator.isDecimal ? .decimalPad : .numberPad)
                    .font(.title2)
                    .foregroundStyle(Color.accentColor)
                    .padding()
                    .frame(width: 100)
                    .background(Color.secondaryButton)
                    .clipShape(.rect(cornerRadius: 8))
                
                Text(indicator.unitOfMeasurement ?? "Units")
                    .font(.title2)
                    .bold()
            }
            .fontDesign(.rounded)
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    QuantitativeInput(index: 0)
        .environmentObject(ModelData())
}
