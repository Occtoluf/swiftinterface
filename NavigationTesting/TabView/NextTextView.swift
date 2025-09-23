//
//  NextTextView.swift
//  NavigationTesting
//
//  Created by Иван Сеник on 18.06.2025.
//
import SwiftUI

struct NextTextView: View {
    @Binding var statistic: Int
        @State private var inputText: String = ""
        @Environment(\.dismiss) var dismiss
        
        var body: some View {
            VStack(spacing: 20) {
                TextField("Введите новое значение", text: $inputText)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                    .padding()
                    .onAppear {
                        inputText = "\(statistic)" // Инициализируем текущим значением
                    }
                
                HStack(spacing: 30) {
                    Button("Отмена") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                    
                    Button("Сохранить") {
                        if let newValue = Int(inputText) {
                            statistic = newValue
                        }
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
            }
            .navigationTitle("Редактирование")
//            .toolbar(.hidden, for: .navigationBar)
        }
    }
