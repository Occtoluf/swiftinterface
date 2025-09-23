//
//  ContentView.swift
//  NavigationTesting
//
//  Created by Иван Сеник on 28.05.2025.
//

import SwiftUI

struct ActivityView: View {
    let headerColor = LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .bottomLeading, endPoint: .topTrailing)
    @State private var myStatistic1 = 42
    @State private var myStatistic2 = 14
    @State private var myStatistic3 = 3
    @State private var myStatistic4 = 7

    var body: some View {
        NavigationView {
            ZStack {
                headerColor
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 0) {
                    HeaderView()
                    VStack(){
                        CheckInHistory()
                            .padding(.bottom)
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
                        HStack {
                            NextViewButton(startColor: Color(hex:"#42aaff"),
                                           endColor: Color(hex:"#a544d4"),
                                           name: "Занятий",
                                           lastName: "посещено",
                                           statistic: $myStatistic1,
                                           icon:"waveform.path.ecg",
                                           commentary: "Это больше на **20%** чем ранее",)
                            NextViewButton(startColor: Color(hex:"#a544d4"),
                                           endColor: Color(hex:"#44d4a5"),
                                           name: "Занятий",
                                           lastName: "групповых",
                                           statistic: $myStatistic2,
                                           icon:"figure.yoga",
                                           commentary: "Это меньше на **11%** чем ранее",)
                        }
                        .padding(.top)
                        HStack {
                            NextViewButton(startColor: Color(hex:"#DAA520"),
                                           endColor: Color(hex:" #FF4500"),
                                           name: "Минут",
                                           lastName: "на кардио",
                                           statistic: $myStatistic3,
                                           icon:"clock",
                                           commentary: "Это **рекорд** среди ваших друзей",)
                            NextViewButton(startColor: Color(hex:"#FF4500"),
                                           endColor: Color(hex:"#a3b414"),
                                           name: "Дней",
                                           lastName: "подряд",
                                           statistic: $myStatistic4,
                                           icon:"hare",
                                           commentary: "Вы входите в **топ** по посещаемости",)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color.black)
                    .clipShape(
                        .rect(
                            topLeadingRadius: 30,
                            topTrailingRadius: 30,
                        )
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
}

// Экран назначения
struct DetailView: View {
    var body: some View {
        Text("Детальный просмотр")
            .navigationTitle("Детали")
    }
}

#Preview {
    ActivityView()
}

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
