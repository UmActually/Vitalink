//
//  IndicatorSelection.swift
//  Vitalink
//
//  Created by Leonardo Corona Garza on 11/23/23.
//

import SwiftUI

struct IndicatorSelection: View {
    static let gridItems: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    @EnvironmentObject var modelData: ModelData
    @State private var indicators: [HealthIndicator]? = nil
    @State private var suggested: [HealthIndicator]? = nil
    @State private var search = ""
    @State private var activateNavLink = false
    
    var didSelect: Bool {
        !modelData.selectedIndicators.isEmpty
    }
    
    var body: some View {
        NavigationView {
            if indicators != nil, suggested != nil {
                let indicators = filterIndicators()
                let suggested = suggested!
                
                ZStack(alignment: .bottom) {
                    NavigationLink(destination: AddRecordsView(), isActive: $activateNavLink) {
                        EmptyView()
                    }
                    
                    List {
                        Section(content: {
                            LazyVGrid(columns: Self.gridItems) {
                                ForEach(suggested) { indicator in
                                    SuggestedIndicator(indicator: indicator)
                                }
                            }
                            .padding(.vertical, 10)
                        }, header: {
                            Text("Sugeridos")
                        })
                        
                        Section(content: {
                            ForEach(indicators) { indicator in
                                IndicatorElement(indicator: indicator)
                            }
                        }, header: {
                            Text("Todos")
                        })
                    }
                    .searchable(text: $search, placement: .navigationBarDrawer(displayMode: .always), prompt: "Buscar")
                    
                    if didSelect {
                        AccentButton(label: "Continuar") {
                            var recordInputs = [HealthRecordInput]()
                            for indicator in modelData.selectedIndicators {
                                recordInputs.append(.init(healthIndicator: indicator, value: indicator.min, note: ""))
                            }
                            modelData.recordInputs = recordInputs
                            activateNavLink = true
                        }
                    }
                }
                .navigationTitle("Indicadores")
            } else {
                ProgressView("Cargando...")
                    .progressViewStyle(.circular)
                    .navigationTitle("Indicadores")
            }
        }
        .task {
            let indicatorsResult: IndicatorsResult = await API.call("indicators/")
            switch indicatorsResult {
            case .success(let value):
                indicators = value
            case .failure(_):
                break
            }
            
            let suggestedResult: IndicatorsResult = await API.call("indicators/suggested/")
            switch suggestedResult {
            case .success(let value):
                suggested = value
            case .failure(_):
                break
            }
        }
    }
    
    func filterIndicators() -> [HealthIndicator] {
        if search.isEmpty {
            return indicators!
        }
        
        return indicators!.filter {
            let lowercasedSearch = search.lowercased()
            let medicalName = $0.medicalName?.lowercased() ?? ""
            return $0.name.lowercased().contains(lowercasedSearch) || medicalName.contains(lowercasedSearch)
        }
    }
}

#Preview {
    IndicatorSelection()
        .environmentObject(ModelData())
}
