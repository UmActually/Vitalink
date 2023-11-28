//
//  HistoryView.swift
//  Vitalink
//
//  Created by Leonardo Corona Garza on 11/15/23.
//

import SwiftUI

struct HistoryView: View {
    let patientID: Int?
    let endpoint: String
    let navigationTitle: String
    
    init() {
        patientID = nil
        endpoint = "records/history/"
        navigationTitle = "Historial"
    }
    
    init(patientID: Int, patientName: String) {
        self.patientID = patientID
        endpoint = "users/\(patientID)/history/"
        navigationTitle = patientName
    }
    
    @EnvironmentObject var modelData: ModelData
    
    @State private var history: HealthRecordHistory? = nil
    @State private var alertPresented = false
    @State private var alertText = ""
    @State private var loadingMore = false
    
    var body: some View {
        Group {
            if let history = history {
                List {
                    ForEach(history.results, id: \.self[0].id) { dayRecords in
                        Section(content: {
                            ForEach(dayRecords) { record in
                                NavigationLink(destination: {
                                    if let patientID = patientID {
                                        // Vista de doctor
                                        IndicatorHistory(patientID: patientID, indicator: record.healthIndicator)
                                    } else {
                                        // Vista de paciente
                                        IndicatorHistory(indicator: record.healthIndicator)
                                    }
                                }) {
                                    HistoryElement(record: record)
                                }
                            }
                            .onDelete { offsets in
                                Task {
                                    for index in offsets {
                                        let recordID = dayRecords[index].id
                                        let result: StringResult = await API.call("records/\(recordID)/", method: .delete)
                                        switch result {
                                        case .success(_):
                                            modelData.manuallyReloadViews.toggle()
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
                    // "http://10.14.255.92:8000/" -> 25
                    if let next = history.next?.dropFirst(25) {
                        HStack {
                            Spacer()
                            Button(loadingMore ? "Cargando..." : "Cargar Más") {
                                Task {
                                    withAnimation {
                                        loadingMore = true
                                    }
                                    let result: HistoryResult = await API.call(String(next))
                                    loadingMore = false
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
                .id(modelData.manuallyReloadViews)
                .listStyle(.insetGrouped)
                .navigationTitle(navigationTitle)
            } else {
                ProgressView("Cargando...")
                    .progressViewStyle(.circular)
                    .navigationTitle(navigationTitle)
            }
        }
        .alert("Error", isPresented: $alertPresented) {
            Button("OK") {}
        } message: {
            Text(alertText)
        }
        .task {
            let result: HistoryResult = await API.call(endpoint)
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
        .environmentObject(ModelData())
}
