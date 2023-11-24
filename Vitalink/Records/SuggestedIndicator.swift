//
//  SuggestedIndicator.swift
//  Vitalink
//
//  Created by Leonardo Corona Garza on 11/23/23.
//

import SwiftUI

struct SuggestedIndicator: View {
    let indicator: HealthIndicator
    
    @EnvironmentObject var modelData: ModelData
    
    var isSelected: Bool {
        modelData.selectedIndicators.contains(indicator)
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(isSelected ? Color.accentColor : Color.secondaryButton)
                .clipShape(.rect(cornerRadius: 8))
            
            VStack(alignment: .leading) {
                Text(indicator.name)
                    .fontDesign(.rounded)
                    .font(.headline)
                    .foregroundStyle(isSelected ? .white : .primary)
                if let medicalName = indicator.medicalName {
                    Text(medicalName)
                        .font(.caption2)
                        .italic()
                        .foregroundStyle(isSelected ? .white : .secondary)
                }
            }
            .padding()
        }
        .onTapGesture {
            withAnimation(.snappy) {
                if isSelected {
                    modelData.selectedIndicators.remove(indicator)
                } else {
                    modelData.selectedIndicators.insert(indicator)
                }
            }
        }
    }
}

#Preview {
    SuggestedIndicator(indicator: HealthRecord.sample.healthIndicator)
        .environmentObject(ModelData())
}
