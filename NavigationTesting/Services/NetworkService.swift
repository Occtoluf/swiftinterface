//
//  NetworkService.swift
//  NavigationTesting
//
//  Created for MVVM Architecture Implementation
//

import Foundation
import Combine

// MARK: - Network Service Protocol
protocol NetworkServiceProtocol {
    func fetchUserStatistics(userId: Int) async throws -> UserStatistics
    func fetchActivityHistory(userId: Int) async throws -> [ActivityHistory]
    func fetchUserProfile(userId: Int) async throws -> UserProfile
}

// MARK: - Network Service Implementation
class NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService()
    
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    
    // Базовые URL для Mock API
    private let baseURL = "https://jsonplaceholder.typicode.com" // Сменим на собственный мок
    private let mockDataURL = "https://raw.githubusercontent.com/Occtoluf/swiftinterface/main/MockData"
    
    private init() {
        decoder.dateDecodingStrategy = .iso8601
    }
    
    // MARK: - Fetch User Statistics
    func fetchUserStatistics(userId: Int) async throws -> UserStatistics {
        // Мок данные для статистики
        let mockStatistics = UserStatistics(
            id: 1,
            userId: userId,
            workoutCount: Int.random(in: 35...50),
            groupWorkoutCount: Int.random(in: 10...20),
            cardioMinutes: Int.random(in: 120...300),
            streakDays: Int.random(in: 3...14),
            lastUpdated: ISO8601DateFormatter().string(from: Date()),
            workoutGrowth: Double.random(in: -15...25),
            groupWorkoutGrowth: Double.random(in: -20...15),
            cardioGrowth: Double.random(in: -10...30),
            streakGrowth: Double.random(in: 0...50)
        )
        
        // Симуляция задержки сети
        try await Task.sleep(nanoseconds: UInt64.random(in: 1_000_000_000...3_000_000_000))
        
        // Симуляция случайных ошибок (5% шанс)
        if Int.random(in: 1...20) == 1 {
            throw NetworkError.networkError("Ошибка соединения с сервером")
        }
        
        return mockStatistics
    }
    
    // MARK: - Fetch Activity History
    func fetchActivityHistory(userId: Int) async throws -> [ActivityHistory] {
        let activities = [
            ActivityHistory(
                id: 1,
                userId: userId,
                activityType: "Силовая тренировка",
                date: dateString(daysAgo: 1),
                duration: 60,
                calories: 320,
                notes: "Проработка верха тела"
            ),
            ActivityHistory(
                id: 2,
                userId: userId,
                activityType: "Кардио",
                date: dateString(daysAgo: 2),
                duration: 45,
                calories: 280,
                notes: "Бег на беговой дорожке"
            ),
            ActivityHistory(
                id: 3,
                userId: userId,
                activityType: "Групповое занятие",
                date: dateString(daysAgo: 3),
                duration: 90,
                calories: 450,
                notes: "Йога для начинающих"
            )
        ]
        
        // Симуляция задержки
        try await Task.sleep(nanoseconds: UInt64.random(in: 500_000_000...2_000_000_000))
        
        return activities
    }
    
    // MARK: - Fetch User Profile
    func fetchUserProfile(userId: Int) async throws -> UserProfile {
        let profile = UserProfile(
            id: userId,
            name: "Иван Сеник",
            email: "ivan.senik@example.com",
            avatarUrl: nil,
            memberSince: "2024-01-15",
            fitnessGoals: ["Похудеть", "Набрать мышечную массу", "Улучшить выносливость"]
        )
        
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        return profile
    }
    
    // MARK: - Helper Methods
    private func dateString(daysAgo: Int) -> String {
        let date = Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date()) ?? Date()
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: date)
    }
}

// MARK: - Mock Service for Testing
class MockNetworkService: NetworkServiceProtocol {
    var shouldFail = false
    var delay: UInt64 = 1_000_000_000
    
    func fetchUserStatistics(userId: Int) async throws -> UserStatistics {
        try await Task.sleep(nanoseconds: delay)
        
        if shouldFail {
            throw NetworkError.networkError("Мок-ошибка для тестирования")
        }
        
        return UserStatistics(
            id: 1,
            userId: userId,
            workoutCount: 42,
            groupWorkoutCount: 14,
            cardioMinutes: 180,
            streakDays: 7,
            lastUpdated: ISO8601DateFormatter().string(from: Date()),
            workoutGrowth: 20.0,
            groupWorkoutGrowth: -11.0,
            cardioGrowth: 35.0,
            streakGrowth: 40.0
        )
    }
    
    func fetchActivityHistory(userId: Int) async throws -> [ActivityHistory] {
        try await Task.sleep(nanoseconds: delay)
        return []
    }
    
    func fetchUserProfile(userId: Int) async throws -> UserProfile {
        try await Task.sleep(nanoseconds: delay)
        return UserProfile(
            id: userId,
            name: "Мок Пользователь",
            email: "mock@test.com",
            avatarUrl: nil,
            memberSince: "2024-01-01",
            fitnessGoals: ["Тест"]
        )
    }
}