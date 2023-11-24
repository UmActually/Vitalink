//
//  AddRecordsView.swift
//  Vitalink
//
//  Created by Leonardo Corona Garza on 11/23/23.
//

import SwiftUI

struct AddRecordsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var modelData: ModelData
    
    @State private var loading = false
    
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
            
            AccentButton(label: "Listo") {
                Task {
                    loading = true
                    let result = await modelData.postRecords()
                    loading = false
                    switch result {
                    case .success(_):
                        dismiss()
                        try! await Task.sleep(nanoseconds: 50_000_000)
                        modelData.tab = .home
                        modelData.selectedIndicators.removeAll()
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            
            if loading {
                LoadingOverlay(message: "Completando registro...")
                    .frame(maxHeight: .infinity)
            }
        }
        .navigationTitle("Registros")
    }
}

#Preview {
    AddRecordsView()
        .environmentObject(ModelData())
}
