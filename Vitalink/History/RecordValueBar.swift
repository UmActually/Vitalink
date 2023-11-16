//
//  RecordValueBar.swift
//  Vitalink
//
//  Created by Leonardo Corona Garza on 11/15/23.
//

import SwiftUI

struct RecordValueBar: View {
    static let green = Color(red: 26 / 255, green: 180 / 255, blue: 57 / 255)
    static let yellow = Color(red: 239 / 255, green: 172 / 255, blue: 120 / 255)
    static let red = Color(red: 239 / 255, green: 120 / 255, blue: 221 / 255)
    
    var value: Double
    
    var body: some View {
        ZStack {
            Rectangle()
                .clipShape(.rect(cornerRadius: 3))
                .frame(width: 50, height: 6)
                .foregroundStyle(LinearGradient(
                    gradient: Gradient(colors: [Self.green, Self.yellow, Self.red]),
                    startPoint: UnitPoint(x: -0.1, y: 0),
                    endPoint: UnitPoint(x: 1, y: 0)))
            
            Rectangle()
                .clipShape(.rect(cornerRadius: 3))
                .frame(width: 6, height: 12)
                .offset(x: CGFloat((value / 10) * 50 - 25))
        }
    }
}

#Preview {
    RecordValueBar(value: 8)
}
