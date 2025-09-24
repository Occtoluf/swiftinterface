//
//  ActivityModels.swift
//  NavigationTesting
//
//  Created for MVVM Architecture Implementation
//

import Foundation

// MARK: - User Statistics Model
struct UserStatistics: Codable, Identifiable {
    let id: Int
    let userId: Int
    let workoutCount: Int
    let groupWorkoutCount: Int
    let cardioMinutes: Int
    let streakDays: Int
    let lastUpdated: String
    
    // Статистика изменений для комментариев
    let workoutGrowth: Double
    let groupWorkoutGrowth: Double
    let cardioGrowth: Double
    let streakGrowth: Double
}

// MARK: - Activity History Model
struct ActivityHistory: Codable, Identifiable {
    let id: Int
    let userId: Int
    let activityType: String
    let date: String
    let duration: Int
    let calories: Int
    let notes: String?
}

// MARK: - User Profile Model
struct UserProfile: Codable {
    let id: Int
    let name: String
    let email: String
    let avatarUrl: String?
    let memberSince: String
    let fitnessGoals: [String]
}

// MARK: - API Response Wrappers
struct StatisticsResponse: Codable {
    let success: Bool
    let data: UserStatistics
    let message: String?
}

struct ActivitiesResponse: Codable {
    let success: Bool
    let data: [ActivityHistory]
    let message: String?
}

struct ProfileResponse: Codable {
    let success: Bool
    let data: UserProfile
    let message: String?
}

// MARK: - Error Handling
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case networkError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Неверный URL"
        case .noData:
            return "Нет данных от сервера"
        case .decodingError:
            return "Ошибка обработки данных"
        case .networkError(let message):
            return "Сетевая ошибка: \(message)"
        }
    }
}

// MARK: - Loading States
enum LoadingState {
    case idle
    case loading
    case success
    case error(NetworkError)
}