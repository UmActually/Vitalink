//
//  HistoryElement.swift
//  Vitalink
//
//  Created by Leonardo Corona Garza on 11/16/23.
//

import SwiftUI

struct HistoryElement: View {
    let name: String
    let medicalName: String?
    let value: Double
    let valueString: String
    let unitOfMeasurement: String?
    let isCuantitative: Bool
    let date: String
    let time: String
    let note: String?
    let includeDate: Bool
    
    init(record: HealthRecord, includeDate: Bool = false) {
        name = record.healthIndicator.name
        medicalName = record.healthIndicator.medicalName
        value = record.value
        if record.healthIndicator.isDecimal {
            valueString = String(record.value)
        } else {
            valueString = String(Int(record.value))
        }
        unitOfMeasurement = record.healthIndicator.unitOfMeasurement
        isCuantitative = record.healthIndicator.isCuantitative
        date = historyDateFormatter.string(from: record.date)
        time = historyTimeFormatter.string(from: record.date)
        note = record.note
        self.includeDate = includeDate
    }
    
    init(record: MinimalHealthRecord, indicator: HealthIndicator, includeDate: Bool = false) {
        name = indicator.name
        medicalName = indicator.medicalName
        value = record.value
        if indicator.isDecimal {
            valueString = String(record.value)
        } else {
            valueString = String(Int(record.value))
        }
        unitOfMeasurement = indicator.unitOfMeasurement
        isCuantitative = indicator.isCuantitative
        date = shortHistoryDateFormatter.string(from: record.date)
        time = historyTimeFormatter.string(from: record.date)
        note = record.note
        self.includeDate = includeDate
    }
    
    var body: some View {
        HStack {
            VStack {
                if includeDate {
                    Text(date)
                        .font(.caption)
                        .bold()
                        .frame(maxWidth: 56)
                }
                Text(time)
                    .font(.caption)
            }
            HStack {
                VStack(alignment: .leading) {
                    Text(name)
                        .fontDesign(.rounded)
                        .font(.headline)
                    if let medicalName = medicalName {
                        Text(medicalName)
                            .font(.caption2)
                            .italic()
                            .foregroundStyle(.secondary)
                    }
                    if let note = note {
                        Text(note)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
                VStack {
                    HStack(alignment: .firstTextBaseline) {
                        Text(valueString)
                            .fontDesign(.rounded)
                            .font(.title)
                            .bold()
                        Text(unitOfMeasurement ?? "/10")
                            .fontDesign(.rounded)
                    }
                    if !isCuantitative {
                        RecordValueBar(value: value)
                    }
                }
                
            }
            .padding()
        }
    }
}

let shortHistoryDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    return formatter
}()

let historyDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}()

let historyTimeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    return formatter
}()

#Preview {
    HistoryElement(record: .sample)
}
