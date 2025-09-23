//
//  TestingThings.swift
//  NavigationTesting
//
//  Created by Иван Сеник on 28.05.2025.
//

import SwiftUI

struct TestingThings: View {
    var body: some View {
        HStack(spacing: 16) { // Отступ между кнопками
            SquareButton(title: "Кнопка 1", color: .blue)
            SquareButton(title: "Кнопка 2", color: .green)
        }
        .padding(16) // Отступы от краев экрана
    }
}

struct SquareButton: View {
    let title: String
    let color: Color
    
    var body: some View {
        Button(action: {}) {
            Text(title)
                .font(.title)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Заполнение всего пространства
                .background(color)
        }
        .aspectRatio(1, contentMode: .fit) // Сохраняем соотношение сторон 1:1
        .cornerRadius(20) // Закругление углов
    }
}

#Preview {
    TestingThings()
}
