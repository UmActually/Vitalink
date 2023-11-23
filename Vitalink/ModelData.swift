//
//  ModelData.swift
//  Vitalink
//
//  Created by Leonardo Corona Garza on 11/22/23.
//

import Foundation

final class ModelData: ObservableObject {
    @Published var manuallyReloadViews = false
    
    // Tab de la vista principal
    @Published var tab: Tab = .home
    
    // Datos de registro
    @Published var firstNames = ""
    @Published var lastNames = ""
    @Published var email = ""
    @Published var phoneNumber = ""
    @Published var birthDate = Date()
    
    @Published var password = ""
    
    @Published var height = ""
    @Published var medicalHistory = ""
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

enum Tab {
    case home, newRecord, profile
}
