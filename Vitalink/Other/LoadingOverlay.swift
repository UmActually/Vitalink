//
//  LoadingOverlay.swift
//  Vitalink
//
//  Created by Leonardo Corona Garza on 11/20/23.
//

import SwiftUI

struct LoadingOverlay: View {
    let message: String
    
    init(message: String = "Cargando...") {
        self.message = message
    }
    
    var body: some View {
        ProgressView(message)
            .fontDesign(.rounded)
            .foregroundStyle(.white)
            .padding()
            .background()
            .backgroundStyle(Color(red: 0, green: 0, blue: 0, opacity: 0.75))
            .clipShape(.rect(cornerRadius: 8))
    }
}

#Preview {
    LoadingOverlay()
}
