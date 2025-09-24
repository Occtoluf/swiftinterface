//
//  ActivityView.swift
//  NavigationTesting
//
//  Refactored to MVVM Architecture
//  Created by Иван Сеник on 28.05.2025.
//

import SwiftUI

struct ActivityView: View {
    let headerColor = LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .bottomLeading, endPoint: .topTrailing)
    
    // MVVM: Заменяем @State на @ObservedObject
    @ObservedObject private var viewModel = ActivityViewModel()
    
    // Состояние для pull-to-refresh
    @State private var isRefreshing = false
    
    var body: some View {
        NavigationView {
            ZStack {
                headerColor
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 0) {
                    HeaderView()
                    
                    // Основной контент с обработкой состояний
                    Group {
                        if viewModel.isLoading && viewModel.statistics == nil {
                            // Первоначальная загрузка
                            LoadingView()
                        } else if viewModel.hasError && viewModel.statistics == nil {
                            // Ошибка при первой загрузке
                            ErrorView(errorMessage: viewModel.errorMessage) {
                                Task { await viewModel.retryLoading() }
                            }
                        } else {
                            // Основной контент
                            StatisticsContentView(viewModel: viewModel, isRefreshing: $isRefreshing)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.bottom)
            }
        }
        .task {
            // Загружаем данные при появлении View
            await viewModel.loadInitialData()
        }
        .alert("Ошибка загрузки", isPresented: .constant(viewModel.hasError && viewModel.statistics != nil)) {
            Button("Повторить") {
                Task { await viewModel.retryLoading() }
            }
            Button("Отмена", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

// MARK: - Statistics Content View
struct StatisticsContentView: View {
    @ObservedObject var viewModel: ActivityViewModel
    @Binding var isRefreshing: Bool
    
    var body: some View {
        VStack(){
            CheckInHistory()
                .padding(.bottom)
            
            // Период статистики
            HStack{
                Text("Неделя")
                    .padding(4)
                    .frame(maxWidth: .infinity)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.white, lineWidth: 1)
                    }
                
                Text("Месяц")
                    .frame(maxWidth: .infinity)
                Text("Все время")
                    .frame(maxWidth: .infinity)
                    .padding(4)
            }
            .foregroundStyle(Color.white)
            
            // Статистические виджеты (теперь с данными из ViewModel)
            HStack {
                NextViewButton(
                    startColor: Color(hex:"#42aaff"),
                    endColor: Color(hex:"#a544d4"),
                    name: "Занятий",
                    lastName: "посещено",
                    statistic: .constant(viewModel.workoutCount), // Реальные данные!
                    icon:"waveform.path.ecg",
                    commentary: viewModel.workoutGrowthText
                )
                NextViewButton(
                    startColor: Color(hex:"#a544d4"),
                    endColor: Color(hex:"#44d4a5"),
                    name: "Занятий",
                    lastName: "групповых",
                    statistic: .constant(viewModel.groupWorkoutCount), // Реальные данные!
                    icon:"figure.yoga",
                    commentary: viewModel.groupWorkoutGrowthText
                )
            }
            .padding(.top)
            
            HStack {
                NextViewButton(
                    startColor: Color(hex:"#DAA520"),
                    endColor: Color(hex:" #FF4500"),
                    name: "Минут",
                    lastName: "на кардио",
                    statistic: .constant(viewModel.cardioMinutes), // Реальные данные!
                    icon:"clock",
                    commentary: viewModel.cardioGrowthText
                )
                NextViewButton(
                    startColor: Color(hex:"#FF4500"),
                    endColor: Color(hex:"#a3b414"),
                    name: "Дней",
                    lastName: "подряд",
                    statistic: .constant(viewModel.streakDays), // Реальные данные!
                    icon:"hare",
                    commentary: viewModel.streakGrowthText
                )
            }
            
            Spacer()
        }
        .padding()
        .background(Color.black)
        .clipShape(
            .rect(
                topLeadingRadius: 30,
                topTrailingRadius: 30
            )
        )
        .refreshable {
            // Pull-to-refresh функциональность
            isRefreshing = true
            await viewModel.refreshData()
            isRefreshing = false
        }
        .overlay(
            // Индикатор обновления
            Group {
                if viewModel.isLoading && viewModel.statistics != nil {
                    VStack {
                        HStack {
                            ProgressView()
                                .scaleEffect(0.8)
                            Text("Обновление...")
                                .font(.caption)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.black.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        Spacer()
                    }
                    .padding(.top, 10)
                }
            }
        )
    }
}

// MARK: - Loading View
struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
            
            Text("Загрузка статистики...")
                .foregroundColor(.white)
                .font(.headline)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.8))
        .clipShape(
            .rect(
                topLeadingRadius: 30,
                topTrailingRadius: 30
            )
        )
    }
}

// MARK: - Error View
struct ErrorView: View {
    let errorMessage: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.orange)
            
            Text("Ошибка загрузки")
                .font(.headline)
                .foregroundColor(.white)
            
            Text(errorMessage)
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            Button("Повторить") {
                retryAction()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.8))
        .clipShape(
            .rect(
                topLeadingRadius: 30,
                topTrailingRadius: 30
            )
        )
    }
}

// Экран назначения - остается без изменений
struct DetailView: View {
    var body: some View {
        Text("Детальный просмотр")
            .navigationTitle("Детали")
    }
}

#Preview {
    ActivityView()
}

// MARK: - Extensions (остаются без изменений)
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct RoundedCorner: Shape {
    let radius: CGFloat
    let corners: UIRectCorner

    init(radius: CGFloat = .infinity, corners: UIRectCorner = .allCorners) {
        self.radius = radius
        self.corners = corners
    }

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct HeaderView: View {
    var body: some View {
        HStack{
            Image(systemName: "dumbbell")
            Text("FitnessApp")
        }
        .frame(maxWidth: .infinity, minHeight: 80)
        .font(.largeTitle)
    }
}

struct NextViewButton: View {
    let startColor:Color
    let endColor:Color
    let name:String
    let lastName:String
    @Binding var statistic:Int
    let icon:String
    var commentary: String
        
    
    var body: some View {
        NavigationLink{(NextTextView(statistic: $statistic))}
        label: {
            VStack(alignment: .leading){
                VStack(alignment: .leading){
                    HStack{
                        Text(name)
                        Spacer()
                        Image(systemName: icon)
                    }
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                    Text(lastName)
                }
                .font(.system(size: 23))
                .fontWeight(.medium)
                Text("\(statistic)")
                    .font(.largeTitle)
                    .bold()
                    .contentTransition(.numericText())
                Text(LocalizedStringKey(commentary))
                    .font(.callout)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundColor(.white)
            .aspectRatio(1, contentMode: .fit)
            .background(LinearGradient(gradient: Gradient(colors: [startColor
                                                                   , endColor]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(20)
            .padding(4)
        }
        .buttonStyle(PlainButtonStyle())
        .buttonStyle(.plain)
        .contentShape(Rectangle())

    }
}

struct CheckInHistory: View {
    var body: some View {
        NavigationLink(destination: DetailView()){
            HStack{
                Image(systemName: "figure.walk.arrival")
                    .scaleEffect(x: -1, y: 1)
                Text("История посещений")
                Spacer()
                Image(systemName: "chevron.right")
            }
        }
        .foregroundStyle(Color.white)
        .padding()
        .background(Color.gray.opacity(0.3))
        .cornerRadius(12)
    }
}