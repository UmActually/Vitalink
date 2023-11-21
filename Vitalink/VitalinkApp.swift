//
//  VitalinkApp.swift
//  Vitalink
//
//  Created by Leonardo Corona Garza on 11/13/23.
//

import SwiftUI

@main
struct VitalinkApp: App {
    @StateObject private var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}
