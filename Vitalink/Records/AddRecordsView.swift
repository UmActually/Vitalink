//
//  AddRecordsView.swift
//  Vitalink
//
//  Created by Leonardo Corona Garza on 11/23/23.
//

import SwiftUI

struct AddRecordsView: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        ZStack(alignment: .bottom) {
            List {
                ForEach(modelData.recordInputs, id: \.healthIndicator.id) { record in
                    let index = modelData.recordInputs.firstIndex {
                        $0.healthIndicator.id == record.healthIndicator.id
                    }
                    RecordElement(index: index!)
                }
            }
            
            RegistrationButton(label: "Listo") {
                
            }
        }
        .navigationTitle("Registros")
    }
}

#Preview {
    AddRecordsView()
        .environmentObject(ModelData())
}
