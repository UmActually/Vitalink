//
//  Models.swift
//  Vitalink
//
//  Created by Leonardo Corona Garza on 11/13/23.
//

import Foundation
import SwiftUI

// Para especificar el tipo de resultado cada vez que se use API.call(), ejemplo:
// let result: HistoryResult = await API.call("records/history/")

typealias EmptyResult = Result<[String: String], APIError>
typealias GenericResult = Result<GenericJSON, APIError>
typealias PatientResult = Result<Patient, APIError>
typealias IndicatorResult = Result<HealthIndicator, APIError>
typealias IndicatorsResult = Result<[HealthIndicator], APIError>
typealias RecordResult = Result<HealthRecord, APIError>
typealias HistoryResult = Result<HealthRecordHistory, APIError>
typealias IndicatorHistoryResult = Result<IndicatorSpecificHistory, APIError>
typealias RegistrationResult = Result<RegistrationResponse, APIError>

struct Patient: Codable, Identifiable {
    let id: Int
    let email: String
    let firstNames: String
    let lastNames: String
    let phoneNumber: String?
    let dateJoined: Date
    let birthDate: Date
    let height: Double
    let medicalHistory: String?
    let doctor: Int
}

struct PatientRegistration: Codable {
    let email: String
    let password: String
    let firstNames: String
    let lastNames: String
    let phoneNumber: String?
    let birthDate: String
    let height: Double?
    let medicalHistory: String?
    let doctorId: Int
    
    init(email: String, password: String, firstNames: String, lastNames: String, phoneNumber: String, birthDate: Date, height: String, medicalHistory: String, doctor: Int) {
        self.email = email
        self.password = password
        self.firstNames = firstNames
        self.lastNames = lastNames
        self.phoneNumber = phoneNumber.isEmpty ? nil : phoneNumber
        self.birthDate = Self.dateFormatter.string(from: birthDate)
        self.height = height.isEmpty ? nil : Double(height)
        self.medicalHistory = medicalHistory.isEmpty ? nil : medicalHistory
        self.doctorId = doctor
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
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
    // Info de la paginación. Los attrs son variables
    // por el hecho de ser actualizados al pasar de página.
    var count: Int
    var next: String?
    var previous: String?
    
    // Los registros están agrupodos por día,
    // por eso es lista de listas.
    var results: [[HealthRecord]]
}

struct IndicatorSpecificHistory: Codable {
    // Info de la paginación
    let count: Int
    let next: String?
    let previous: String?
    
    let results: [MinimalHealthRecord]
    let currentMonthCount: Int
}

struct RegistrationResponse: Codable, Identifiable {
    let id: Int
    let token: String
}

enum Tab {
    case home, newRecord, profile
}

final class ModelData: ObservableObject {
    // Tab de la vista principal
    @Published var tab: Tab = .home
    
    // Datos de registro
    @Published var firstNames: String = ""
    @Published var lastNames: String = ""
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    @Published var birthDate: Date = Date()
    
    @Published var password: String = ""
    
    @Published var height: String = ""
    @Published var medicalHistory: String = ""
    @Published var profilePhotoData: Data? = nil
    
    @Published var registrationSuccess = false
    
    func registerUser() async -> RegistrationResult {
        let body = PatientRegistration(
            email: email,
            password: password,
            firstNames: firstNames,
            lastNames: lastNames,
            phoneNumber: phoneNumber,
            birthDate: birthDate,
            height: height,
            medicalHistory: medicalHistory,
            doctor: 2)
        
        return await API.call("users/", method: .post, body: body, requiresToken: false)
    }
}
