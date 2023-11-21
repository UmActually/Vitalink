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
                List {
                    ForEach(history.results, id: \.self[0].id) { dayRecords in
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
                                        let result: EmptyResult = await API.call("records/\(recordID)/", method: .delete)
                                        switch result {
                                        case .success(_):
                                            manuallyReloadView.toggle()
                                        case .failure(_):
                                            break
                                        }
                                    }
                                }
                            }
                        }, header: {
                            Text(historyDateFormatter.string(from: dayRecords[0].date))
                        })
                    }
                    
                    // dropFirst es para quitarle el "http://localhost:80/" -> 20
                    // "http://umm-actually.com/" -> 24
                    if let next = history.next?.dropFirst(24) {
                        HStack {
                            Spacer()
                            Button("Cargar Más") {
                                Task {
                                    let result: HistoryResult = await API.call(String(next))
                                    switch result {
                                    case .success(let value):
                                        withAnimation {
                                            self.history!.results.append(contentsOf: value.results)
                                        }
                                        self.history!.next = value.next
                                        self.history!.count += value.count
                                    case .failure(_):
                                        break
                                    }
                                }
                            }
                            Spacer()
                        }
                    }
                }
                .id(manuallyReloadView)
                .listStyle(.insetGrouped)
                .navigationTitle("Historial")
            } else {
                ProgressView("Cargando...")
                    .progressViewStyle(.circular)
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
