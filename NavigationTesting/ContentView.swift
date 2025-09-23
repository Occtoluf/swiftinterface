//
//  ContentView.swift
//  NavigationTesting
//
//  Created by Иван Сеник on 28.05.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var isQrPresented = false
    @State private var isAnimatedQR = false
    
    
    init() {
        let standardAppearance = UITabBarAppearance()
        standardAppearance.configureWithOpaqueBackground()
        standardAppearance.backgroundColor = UIColor(.black) // Фон
        
        let scrollEdgeAppearance = UITabBarAppearance()
        scrollEdgeAppearance.configureWithTransparentBackground()
        scrollEdgeAppearance.backgroundColor = UIColor(Color.black)
        
        // Применяем настройки
        UITabBar.appearance().standardAppearance = standardAppearance
        UITabBar.appearance().scrollEdgeAppearance = scrollEdgeAppearance
        
        UITabBar.appearance().unselectedItemTintColor = UIColor(.gray) // Цвет неактивных иконок
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            TabView(selection: $selectedTab) {
                ActivityView()
                    .tabItem {makeTabItem("chart.bar.fill", "Активность")}
                    .tag(0)
//                Spacer()
                ProfileView()
                    .tabItem { makeTabItem("person.crop.circle", "Профиль") }
                    .tag(2)
            }
            .accentColor(.white) // Цвет активной иконки
            VStack{
                Spacer()
                Button{
                    withAnimation(.spring()){
                        isQrPresented.toggle()
                    }
                    isAnimatedQR.toggle()
                }
                label:{
                    ZStack {
                        RoundedRectangle(cornerRadius: 40)
                            .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing).opacity(0.7))
                            .frame(
                                    width: UIScreen.main.bounds.width * 0.25,
                                    height: 80
                                )
                        VStack{
                            Image(systemName: "qrcode")
                                .font(.largeTitle)
                                .symbolEffect(.bounce,options: .speed(3), value: isAnimatedQR)
                            Text("Показать QR")
                                .font(.caption)
                        }
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.red, Color.yellow]), startPoint: .leading, endPoint: .trailing))
                    }
                    .padding(19)
                }
                .buttonStyle(.plain)
                }
            .ignoresSafeArea()
            BottomHalfSheetView(isPresenting: $isQrPresented)
        }
    }
    
    private func makeTabItem(_ icon: String, _ title: String) -> some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 20))
            Text(title)
                .font(.system(size: 12))
        }
    }
}



#Preview {
    ContentView()
}
