//
//  IndicatorElement.swift
//  Vitalink
//
//  Created by Leonardo Corona Garza on 11/23/23.
//

import SwiftUI

struct IndicatorElement: View {
    let indicator: HealthIndicator
    
    @EnvironmentObject var modelData: ModelData
    
    var isSelected: Bool {
        modelData.selectedIndicators.contains(indicator)
    }
    
    var icon: String {
        if indicator.addedBy != nil {
            return "person.crop.circle"
        }
        if indicator.isCuantitative {
            return "number.square"
        }
        return "dial.min"
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                // Esto es intencional, es para que se pueda presionar
                .opacity(0.000001)
            
            HStack(alignment: .firstTextBaseline) {
                Text(indicator.name)
                    .fontDesign(.rounded)
                    .font(.headline)
                    .foregroundStyle(isSelected ? .white : .primary)
                if let medicalName = indicator.medicalName {
                    Text(medicalName)
                        .font(.caption2)
                        .italic()
                        .foregroundStyle(isSelected ? .white : .secondary)
                        .lineLimit(1, reservesSpace: true)
                }
                
                Spacer()
                
                Image(systemName: icon)
                    .foregroundStyle(isSelected ? .white : .primary)
            }
            .padding(.horizontal, 2)
            .padding(.vertical, 6)
        }
        .listRowBackground(isSelected ? Color.accentColor : .none)
        .onTapGesture {
            withAnimation(.easeOut) {
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
    IndicatorElement(indicator: HealthRecord.sample.healthIndicator)
        .environmentObject(ModelData())
}
