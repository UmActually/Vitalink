//
//  HistoryView.swift
//  TestsReto
//
//  Created by Leonardo Corona Garza on 11/11/23.
//

import SwiftUI

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

struct HistoryView: View {
    @State private var history: HealthRecordHistory? = nil
    @State private var alertPresented = false
    @State private var alertText = ""
    
    var body: some View {
        NavigationView {
            if let history = history {
                List(history.results, id: \.self[0].id) { dayRecords in
                    Section(content: {
                        ForEach(dayRecords) { record in
                            HealthRecordCard(record: record)
                        }
                        .onDelete { offsets in
                            offsets.forEach { index in
                                let recordID = dayRecords[index].id
                                Task {
                                    let _: EmptyResult = await API.call("records/\(recordID)/", method: .delete)
                                }
                            }
                        }
                    }, header: {
                        Text(formatHeaderDate(dayRecords[0].date))
                    })
                }
                .listStyle(.insetGrouped)
                .navigationTitle("Historial")
            } else {
                Text("Cargando...")
                    .navigationTitle("Historial")
            }
        }
        .alert("Error", isPresented: $alertPresented) {
            Button("OK") {}
        } message: {
            Text(alertText)
        }
        .task {
            let result: HistoryResult = await API.call("records/history/")
            switch result {
            case .success(let value):
                history = value
            case .failure(let error):
                if let response = error.response {
                    let detail = response["detail"] ?? response["message"]!
                    alertText = detail as! String
                    alertPresented = true
                }
            }
        }
    }
}

struct HealthRecordCard: View {
    let record: HealthRecord
    
    var body: some View {
        HStack {
            Text(formatRecordTime(record.date))
                .font(.caption)
            VStack(alignment: .leading) {
                HStack(alignment: .bottom) {
                    VStack {
                        Text(record.healthIndicator.name)
                            .fontDesign(.rounded)
                            .font(.headline)
                        if let medicalName = record.healthIndicator.medicalName {
                            Text(medicalName)
                                .fontDesign(.rounded)
                                .font(.subheadline)
                                .italic()
                                .foregroundStyle(.secondary)
                        }
                    }
                    Spacer()
                    HStack(alignment: .firstTextBaseline) {
                        Text(formatRecordValue(record))
                            .fontDesign(.rounded)
                            .font(.title)
                            .bold()
                        Text(record.healthIndicator.unitOfMeasurement ?? "/10")
                            .fontDesign(.rounded)
                    }
                }
                if let note = record.note {
                    Text(note)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
        }
    }
}

func formatRecordValue(_ record: HealthRecord) -> String {
    if record.healthIndicator.isDecimal {
        return String(record.value)
    }
    return String(Int(record.value))
}

func formatHeaderDate(_ date: Date) -> String {
    historyDateFormatter.string(from: date)
}

func formatRecordTime(_ date: Date) -> String {
    historyTimeFormatter.string(from: date)
}

#Preview {
    HistoryView()
}
