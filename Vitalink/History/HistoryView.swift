//
//  HistoryView.swift
//  Vitalink
//
//  Created by Leonardo Corona Garza on 11/15/23.
//

import SwiftUI

struct HistoryView: View {
    @State private var manuallyReloadView = false
    @State private var history: HealthRecordHistory? = nil
    @State private var alertPresented = false
    @State private var alertText = ""
    
    var body: some View {
        NavigationView {
            if let history = history {
                List(history.results, id: \.self[0].id) { dayRecords in
                    Section(content: {
                        ForEach(dayRecords) { record in
                            NavigationLink(destination: IndicatorHistory(indicator: record.healthIndicator)) {
                                HistoryElement(record: record)
                            }
                        }
                        .onDelete { offsets in
                            Task {
                                for index in offsets {
                                    let recordID = dayRecords[index].id
                                    let _: EmptyResult = await API.call("records/\(recordID)/", method: .delete)
                                }
                                // Esto está MUY sucio, hay que ver una mejor manera maybe
                                try! await Task.sleep(nanoseconds: 500_000_000)
                                manuallyReloadView.toggle()
                            }
                        }
                    }, header: {
                        Text(historyDateFormatter.string(from: dayRecords[0].date))
                    })
                }
                .id(manuallyReloadView)
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

#Preview {
    HistoryView()
}
