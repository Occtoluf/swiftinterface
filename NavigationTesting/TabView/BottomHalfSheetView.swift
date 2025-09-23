//
//  BottomHalfSheetView.swift
//  NavigationTesting
//
//  Created by Иван Сеник on 02.06.2025.
//

import SwiftUI
// Полупрозрачная панель с содержимым, появляющаяся снизу экрана на пол-экрана
struct BottomHalfSheetView: View {
    @Binding var isPresenting: Bool
    @GestureState private var dragOffset = CGSize.zero
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if isPresenting {
                Color.black
                    .opacity(isPresenting ? 0.4 : 0)
                    .ignoresSafeArea()
                    .animation(.easeInOut, value: isPresenting)
                    .onTapGesture {
                        withAnimation{
                            isPresenting = false
                        }
                    }
//                    .transition(.opacity)
            }
            QRView(isPresenting: $isPresenting)
                .offset(y: isPresenting ? (dragOffset.height > 0 ? dragOffset.height : 0) : UIScreen.main.bounds.height)
                .animation(.spring(), value: isPresenting)
                .gesture(
                    DragGesture()
                        .updating($dragOffset) { value, state, _ in
                            // Разрешаем только смахивание вниз
                            if value.translation.height > 0 {
                                state = value.translation
                            }
                        }
                        .onEnded { value in
                            // Если перемещение > 100 или скорость достаточная - закрываем
                            if value.translation.height > 100 || value.predictedEndTranslation.height > 200 {
                                withAnimation(.spring()) {
                                    isPresenting = false
                                }
                            }
                        }
                )
        }
    }
}

struct QRView: View {
    @Binding var isPresenting: Bool
    
    var body: some View {
        VStack{
            Spacer()
            VStack {
                Image("QrCodeSample")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal)
                    .padding(.top)
                Button{
                    withAnimation(.spring){
                        isPresenting = false
                    }
                }
                label:{
                    HStack{
                        Image(systemName: "arrow.down")
                        Text("Закрыть")
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.black)
                    .font(.title)
                    .padding(.bottom, 32)
                }
            }
            .background(Color.white)
            .clipShape(
                .rect(
                    topLeadingRadius: 50,
                    topTrailingRadius: 50,
                )
            )
        }
        .ignoresSafeArea()
    }
}
