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
        TopLevelView()
            .id(modelData.manuallyReloadViews)
    }
}

struct TopLevelView: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        if API.userIsAuthenticated() {
            TabView(selection: $modelData.tab) {
                HistoryView()
                    .tabItem {
                        Label("Inicio", systemImage: "house")
                    }
                    .tag(Tab.home)
                Text("New Record")
                    .tabItem {
                        Label("Registro", systemImage: "plus")
                    }
                    .tag(Tab.newRecord)
                ProfileView()
                    .tabItem {
                        Label("Perfil", systemImage: "person")
                    }
                    .tag(Tab.profile)
            }
            .alert(isPresented: $modelData.registrationSuccess) {
                Alert(title: Text("Alerta"), message: Text("Registro guardado con éxito."), dismissButton: .default(Text("OK")))
            }
        } else {
            WelcomeView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ModelData())
}
