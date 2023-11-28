//
//  IndicatorHistory.swift
//  Vitalink
//
//  Created by Leonardo Corona Garza on 11/15/23.
//

import SwiftUI
import Charts

struct IndicatorHistory: View {
    let indicator: HealthIndicator
    let endpoint: String
    
    init(indicator: HealthIndicator) {
        self.indicator = indicator
        endpoint = "records/indicators/\(indicator.id)/history/"
    }
    
    init(patientID: Int, indicator: HealthIndicator) {
        self.indicator = indicator
        endpoint = "users/\(patientID)/indicators/\(indicator.id)/history/"
    }
    
    @State private var history: IndicatorSpecificHistory? = nil
    
    var body: some View {
        Group {
            if let history = history {
                List {
                    Section {
                        VStack(spacing: 20) {
                            if let medicalName = indicator.medicalName {
                                HStack {
                                    Text("Nombre médico: ") +
                                    Text(medicalName)
                                        .italic()
                                    Spacer()
                                }
                            }
                            IndicatorNumbers(count: history.count, currentMonthCount: history.currentMonthCount)
                        }
                        .padding(.vertical)
                    }
                    Section {
                        Chart {
                            ForEach(history.results) { record in
                                LineMark(
                                    x: .value("Date", record.date),
                                    y: .value("Value", record.value)
                                )
                            }
                        }
                        .chartXAxisLabel("Tiempo")
                        .chartYAxisLabel(indicator.unitOfMeasurement ?? "Intensidad")
                        .chartYAxis {
                            AxisMarks(values: .automatic(desiredCount: 5))
                        }
                        .chartYScale(domain: [indicator.min, indicator.max])
                        .frame(height: 250)
                        .padding()
                    }
                    Section(content: {
                        ForEach(history.results) { record in
                            HistoryElement(record: record, indicator: indicator, includeDate: true)
                        }
                    }, header: {
                        Text("Registros")
                    })
                }
                .navigationTitle(indicator.name)
                .navigationBarTitleDisplayMode(.inline)
            } else {
                Text("Cargando...")
                    .navigationTitle(indicator.name)
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
        .task {
            let result: IndicatorHistoryResult = await API.call(endpoint)
            switch result {
            case .success(let value):
                history = value
            case .failure(_):
                break
            }
        }
    }
}

struct IndicatorNumbers: View {
    let count: Int
    let currentMonthCount: Int
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text(String(count))
                    .fontDesign(.rounded)
                    .font(.title)
                    .bold()
                Text("Registros")
                    .fontDesign(.rounded)
            }
            Spacer()
            Divider()
            Spacer()
            VStack {
                Text(String(currentMonthCount))
                    .fontDesign(.rounded)
                    .font(.title)
                    .bold()
                Text("En \(spanishMonthName())")
                    .fontDesign(.rounded)
            }
            Spacer()
        }
    }
}

let months = ["enero", "febrero", "marzo", "abril", "mayo", "junio", "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre"]

func spanishMonthName() -> String {
    let index = Calendar.current.component(.month, from: Date())
    return months[index - 1]
}

#Preview {
    IndicatorHistory(indicator: HealthRecord.sample.healthIndicator)
//    IndicatorStatistics()
}
