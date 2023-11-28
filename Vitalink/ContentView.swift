//
//  ContentView.swift
//  Vitalink
//
//  Created by Leonardo Corona Garza on 11/13/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        if API.userIsAuthenticated() {
            if let userRole = API.userRole() {
                switch userRole {
                case .patient:
                    PatientTopLevel()
                case .doctor:
                    DoctorTopLevel()
                case .admin:
                    GenericProfile(isAdmin: true)
                }
            } else {
                Image(systemName: "stethoscope")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 120)
                    .foregroundStyle(Color.accentColor)
            }
        } else {
            WelcomeView()
                .id(modelData.manuallyReloadViews)
        }
    }
}

struct PatientTopLevel: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        TabView(selection: $modelData.tab) {
            NavigationView {
                HistoryView()
            }
            .tabItem {
                Label("Inicio", systemImage: "house")
            }
            .tag(Tab.home)
            IndicatorSelection()
                .tabItem {
                    Label("Registros", systemImage: "plus")
                }
                .tag(Tab.newRecord)
            PatientProfile()
                .tabItem {
                    Label("Perfil", systemImage: "person")
                }
                .tag(Tab.profile)
        }
    }
}

struct DoctorTopLevel: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        TabView(selection: $modelData.tab) {
            PatientList()
                .tabItem {
                    Label("Inicio", systemImage: "house")
                }
                .tag(Tab.home)
            GenericProfile(isAdmin: false)
                .tabItem {
                    Label("Perfil", systemImage: "person")
                }
                .tag(Tab.profile)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ModelData())
}
