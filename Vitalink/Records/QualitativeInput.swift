//
//  QualitativeInput.swift
//  Vitalink
//
//  Created by Marcelo García Pablos Vélez on 15/11/23.
//

import SwiftUI

let gradient: [Color] = [
    .init(red: 26 / 255, green: 180 / 255, blue: 57 / 255),
    .init(red: 77 / 255, green: 171 / 255, blue: 76 / 255),
    .init(red: 129 / 255, green: 162 / 255, blue: 96 / 255),
    .init(red: 180 / 255, green: 153 / 255, blue: 115 / 255),
    .init(red: 211 / 255, green: 147 / 255, blue: 120 / 255),
    .init(red: 239 / 255, green: 141 / 255, blue: 126 / 255),
    .init(red: 239 / 255, green: 133 / 255, blue: 138 / 255),
    .init(red: 239 / 255, green: 125 / 255, blue: 150 / 255),
    .init(red: 239 / 255, green: 117 / 255, blue: 162 / 255),
    .init(red: 239 / 255, green: 118 / 255, blue: 191 / 255),
    .init(red: 239 / 255, green: 120 / 255, blue: 221 / 255),
]

struct QualitativeInput: View {
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
            
            HStack(alignment: .firstTextBaseline) {
                Text("\(Int(modelData.recordInputs[index].value))")
                    .keyboardType(indicator.isDecimal ? .decimalPad : .numberPad)
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(gradient[Int(modelData.recordInputs[index].value)])
                
                Text("/\(Int(indicator.max))")
                    .font(.title2)
                    .bold()
            }
            .fontDesign(.rounded)
            .frame(maxWidth: .infinity)
            .padding()
            
            Slider(value: $modelData.recordInputs[index].value, in: indicator.min...indicator.max, step: 1, label: {
                Text("Hola")
            }, minimumValueLabel: {
                Text("Leve")
            }, maximumValueLabel: {
                Text("Intenso")
            }, onEditingChanged: { value in
                
            })
            .fontDesign(.rounded)
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    QualitativeInput(index: 0)
        .environmentObject(ModelData())
}
