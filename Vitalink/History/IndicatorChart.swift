//
//  IndicatorChart.swift
//  Vitalink
//
//  Created by Leonardo Corona Garza on 11/30/23.
//

import SwiftUI
import Charts

struct IndicatorChart: View {
    var data: [IndicatorChartElement]
    let unitOfMeasurement: String?
    let min: Double
    let max: Double
    
    init(history: IndicatorSpecificHistory, unitOfMeasurement: String?, min: Double, max: Double) {
        data = []
        for record in history.results {
            data.append(.init(id: record.id, date: record.date, value: record.value, valueType: .main))
            if let altValue = record.altValue {
                data.append(.init(id: record.id, date: record.date, value: altValue, valueType: .alt))
            }
        }
        self.unitOfMeasurement = unitOfMeasurement
        self.min = min
        self.max = max
    }
    
    var body: some View {
        Chart(data) { record in
            LineMark(
                x: .value("Date", record.date),
                y: .value("Value", record.value)
            )
            .foregroundStyle(by: .value("ValueType", record.valueType))
        }
        .chartXAxisLabel("Tiempo")
        .chartYAxisLabel(unitOfMeasurement ?? "Intensidad")
        .chartYAxis {
            AxisMarks(values: .automatic(desiredCount: 5))
        }
        .chartYScale(domain: [min, max])
        .frame(height: 250)
        .padding()
    }
}

enum ValueType: String, Plottable {
    case main = "Sistólica"
    case alt = "Diastólica"
}

struct IndicatorChartElement: Identifiable {
    let id: Int
    let date: Date
    let value: Double
    let valueType: ValueType
}
