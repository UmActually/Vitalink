//
//  ProfileView.swift
//  Vitalink
//
//  Created by Leonardo Corona Garza on 11/22/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        Button("Cerrar Sesión") {
            API.logout()
            modelData.tab = .home
        }
    }
}

#Preview {
    ProfileView()
}
