//
//  ProfileView.swift
//  NavigationTesting
//
//  Created by Иван Сеник on 28.05.2025.
//

import SwiftUI
import WebKit

struct ProfileView: View {
    let headerColor = LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .bottomLeading, endPoint: .topTrailing)
    var body: some View {
        NavigationStack {
            ZStack{
                headerColor
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 0) {
                    HeaderView()
                    VStack(){
                        ZStack{
                            Text("Профиль")
                                .frame(alignment: .center)
                            Image(systemName: "square.and.pencil")
                                .frame(maxWidth: .infinity, alignment:.trailing)
                        }
                        .foregroundStyle(.white)
                        .font(.title)
                        .padding()
                        Image("ФотоПрофиля")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .shadow(color:.white, radius: 4)
                        ZStack{
                            Text("Иван")
                                .fixedSize()
                                .overlay(Image(systemName: "checkmark.circle")
                                    .background(LinearGradient(gradient: Gradient(colors: [.orange, .green]), startPoint: .leading, endPoint: .trailing))
                                    .cornerRadius(15)
                                    .offset(x: 40), alignment: .trailing
                                         
                                )
                        }
                        .foregroundStyle(.white)
                        //                    .border(.white)
                        .font(.title)
                        ScrollView(){
                            HStack{
                                Text("Абонемент: активен")
                            }
                            .padding(6)
                            .background(LinearGradient(gradient: Gradient(colors: [.green, .blue]), startPoint: .leading, endPoint: .bottomTrailing))
                            .cornerRadius(16)
                            NavigationLink("Сайт Спортмастера", destination: WebView(url:URL(string: "https://sportmaster.ru")!).navigationTitle("Сайт Спортмастера"))
                            NavigationLink("Сайт Demix", destination: WebView(url:URL(string: "https://demix.ru")!).navigationTitle("Сайт Demix"))
                            NavigationLink("Сайт Bosco", destination: WebView(url:URL(string: "https://bosco.ru")!).navigationTitle("Сайт Bosco"))
                            
                                
                                
                            
                        }
                        .foregroundStyle(.white)
                        .font(.title)
                        
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .clipShape(
                        .rect(
                            topLeadingRadius: 30,
                            topTrailingRadius: 30,
                        )
                    )
                }
            }
        }
    }
}

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

#Preview {
    ProfileView()
}
