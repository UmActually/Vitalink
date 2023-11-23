//
//  RecordElement.swift
//  Vitalink
//
//  Created by Leonardo Corona Garza on 11/23/23.
//

import SwiftUI

struct RecordElement: View {
    let index: Int
    
    @EnvironmentObject var modelData: ModelData
    @State private var addNote = false
    
    var indicator: HealthIndicator {
        modelData.recordInputs[index].healthIndicator
    }
    
    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading) {
                    Text(indicator.name)
                        .fontDesign(.rounded)
                        .font(.headline)
                    if let medicalName = indicator.medicalName {
                        Text(medicalName)
                            .font(.caption2)
                            .italic()
                            .foregroundStyle(.secondary)
                    }
                }
                
                if indicator.isCuantitative {
                    QuantitativeInput(index: index)
                } else {
                    QualitativeInput(index: index)
                }
            }
            .padding()
            
            Button(addNote ? "Quitar Nota" : "Agregar Nota") {
                withAnimation(.snappy) {
                    addNote.toggle()
                }
                if !addNote {
                    modelData.recordInputs[index].note = ""
                }
            }
            .fontDesign(.rounded)
            
            if addNote {
                TextEditor(text: $modelData.recordInputs[index].note)
                    .fontDesign(.rounded)
                    .frame(height: 140)
            }
        }
    }
}

#Preview {
    RecordElement(index: 0)
        .environmentObject(ModelData())
}
