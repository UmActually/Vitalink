//
//  ContentView.swift
//  Vitalink
//
//  Created by Leonardo Corona Garza on 11/13/23.
//

import SwiftUI

struct ContentView: View {
    @State private var tab: Tab = .home
    
    var body: some View {
        TabView(selection: $tab) {
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
            Text("Profile")
                .tabItem {
                    Label("Perfil", systemImage: "person")
                }
                .tag(Tab.profile)
        }
    }
}

enum Tab {
    case home, newRecord, profile
}

#Preview {
    ContentView()
}
