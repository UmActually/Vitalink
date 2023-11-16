//
//  Models.swift
//  Vitalink
//
//  Created by Leonardo Corona Garza on 11/13/23.
//

import Foundation

// Para especificar el tipo de resultado cada vez que se use API.call(), ejemplo:
// let result: HistoryResult = await API.call("records/history/")

typealias EmptyResult = Result<[String: String], APIError>
typealias PatientResult = Result<Patient, APIError>
typealias IndicatorResult = Result<HealthIndicator, APIError>
typealias IndicatorsResult = Result<[HealthIndicator], APIError>
typealias RecordResult = Result<HealthRecord, APIError>
typealias HistoryResult = Result<HealthRecordHistory, APIError>
typealias IndicatorHistoryResult = Result<IndicatorSpecificHistory, APIError>

struct Patient: Codable, Identifiable {
    let id: Int
    let email: String
    let firstNames: String
    let lastNames: String
    let phoneNumber: String
    let dateJoined: Date
    let birthDate: Date
    let height: Double
    let medicalHistory: String?
    let doctor: Int
}

struct HealthIndicator: Codable, Identifiable {
    let id: Int
    let name: String
    let medicalName: String?
    let isCuantitative: Bool
    let isDecimal: Bool
    let unitOfMeasurement: String?
    let min: Double
    let max: Double
    let addedBy: Int?
}

struct HealthRecord: Codable, Identifiable {
    let id: Int
    let date: Date
    let value: Double
    let note: String?
    let user: Int
    let healthIndicator: HealthIndicator
    
    static let sample = HealthRecord(id: 1, date: Date(), value: 37.5, note: "Fiebre terminó desde hoy en la mañana.", user: 0, healthIndicator: HealthIndicator(id: 1, name: "Temperatura corporal", medicalName: "Cefalea tensional", isCuantitative: true, isDecimal: true, unitOfMeasurement: "°C", min: 25, max: 50, addedBy: nil))
}

struct MinimalHealthRecord: Codable, Identifiable {
    // Cuando se despliega el historial de un mismo indicador,
    // es redundante tener éste en los JSONs.
    let id: Int
    let date: Date
    let value: Double
    let note: String?
}

struct HealthRecordHistory: Codable {
    // Info de la paginación
    let count: Int
    let next: String?
    let previous: String?
    
    // Los registros están agrupodos por día,
    // por eso es lista de listas.
    let results: [[HealthRecord]]
}

struct IndicatorSpecificHistory: Codable {
    // Info de la paginación
    let count: Int
    let next: String?
    let previous: String?
    
    let results: [MinimalHealthRecord]
    let currentMonthCount: Int
}

// Ejemplos de JSON:

//{
//    "id": 4,
//    "email": "hermenegildo@example.com",
//    "role": 0,
//    "first_names": "Hermenegildo",
//    "last_names": "Pérez Galaz",
//    "phone_number": "8195417619",
//    "date_joined": "2023-11-11T01:03:42.995048-06:00",
//    "birth_date": "1971-02-13",
//    "height": 1.83,
//    "medical_history": null,
//    "doctor": 3
//}

//{
//    "count": 1,
//    "next": null,
//    "previous": null,
//    "results": [
//        {
//            "id": 1,
//            "health_indicator": {
//                "id": 1,
//                "name": "Temperatura corporal",
//                "medical_name": null,
//                "is_cuantitative": true,
//                "is_decimal": true,
//                "unit_of_measurement": "°C",
//                "min": 25.0,
//                "max": 50.0,
//                "added_by": null
//            },
//            "date": "2023-11-11T01:59:56.283675-06:00",
//            "value": 37.4,
//            "note": "Empezó a bajar la fiebre en la mañana.",
//            "user": 4
//        }
//    ]
//}
