//
//  ActivityViewModel.swift
//  NavigationTesting
//
//  Created for MVVM Architecture Implementation
//

import Foundation
import SwiftUI
import Combine

// MARK: - Activity ViewModel
@MainActor
class ActivityViewModel: ObservableObject {
    // MARK: - Published Properties (View будет автоматически обновляться)
    @Published var statistics: UserStatistics?
    @Published var activityHistory: [ActivityHistory] = []
    @Published var loadingState: LoadingState = .idle
    @Published var errorMessage: String = ""
    
    // Отдельные состояния загрузки для разных данных
    @Published var isLoadingStatistics = false
    @Published var isLoadingHistory = false
    @Published var lastRefreshDate: Date?
    
    // MARK: - Computed Properties для View
    var isLoading: Bool {
        case .loading = loadingState
        return true
        default:
        return false
    }
    
    var hasError: Bool {
        if case .error = loadingState {
            return true
        }
        return false
    }
    
    // Получаем статистику для отображения (вместо хардкода)
    var workoutCount: Int {
        statistics?.workoutCount ?? 0
    }
    
    var groupWorkoutCount: Int {
        statistics?.groupWorkoutCount ?? 0
    }
    
    var cardioMinutes: Int {
        statistics?.cardioMinutes ?? 0
    }
    
    var streakDays: Int {
        statistics?.streakDays ?? 0
    }
    
    // Комментарии с ростом/спадом
    var workoutGrowthText: String {
        guard let stats = statistics else { return "Нет данных" }
        let growth = stats.workoutGrowth
        let sign = growth >= 0 ? "+" : ""
        return "Это \(sign)\(Int(growth))% чем ранее"
    }
    
    var groupWorkoutGrowthText: String {
        guard let stats = statistics else { return "Нет данных" }
        let growth = stats.groupWorkoutGrowth
        let sign = growth >= 0 ? "+" : ""
        return "Это \(sign)\(Int(growth))% чем ранее"
    }
    
    var cardioGrowthText: String {
        guard let stats = statistics else { return "Нет данных" }
        let growth = stats.cardioGrowth
        if growth > 30 {
            return "Это **рекорд** среди ваших друзей"
        } else {
            let sign = growth >= 0 ? "+" : ""
            return "Это \(sign)\(Int(growth))% чем ранее"
        }
    }
    
    var streakGrowthText: String {
        guard let stats = statistics else { return "Нет данных" }
        let growth = stats.streakGrowth
        if growth > 35 {
            return "Вы входите в **топ** по посещаемости"
        } else {
            let sign = growth >= 0 ? "+" : ""
            return "Это \(sign)\(Int(growth))% чем ранее"
        }
    }
    
    // MARK: - Dependencies
    private let networkService: NetworkServiceProtocol
    private let userId: Int = 1 // Мок ID пользователя
    
    // MARK: - Initialization
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    // MARK: - Public Methods
    
    /// Основной метод загрузки всех данных
    func loadInitialData() async {
        await fetchAllData()
    }
    
    /// Обновление данных (pull-to-refresh)
    func refreshData() async {
        await fetchAllData()
        lastRefreshDate = Date()
    }
    
    /// Повторная попытка при ошибке
    func retryLoading() async {
        await fetchAllData()
    }
    
    // MARK: - Private Methods
    
    private func fetchAllData() async {
        loadingState = .loading
        errorMessage = ""
        
        do {
            // Параллельная загрузка статистики и истории
            async let statisticsTask = fetchStatistics()
            async let historyTask = fetchActivityHistory()
            
            // Ожидаем оба запроса
            let (stats, history) = try await (statisticsTask, historyTask)
            
            // Обновляем UI
            self.statistics = stats
            self.activityHistory = history
            self.loadingState = .success
            
        } catch let error as NetworkError {
            self.loadingState = .error(error)
            self.errorMessage = error.localizedDescription
        } catch {
            let networkError = NetworkError.networkError(error.localizedDescription)
            self.loadingState = .error(networkError)
            self.errorMessage = networkError.localizedDescription
        }
    }
    
    private func fetchStatistics() async throws -> UserStatistics {
        isLoadingStatistics = true
        defer { isLoadingStatistics = false }
        
        return try await networkService.fetchUserStatistics(userId: userId)
    }
    
    private func fetchActivityHistory() async throws -> [ActivityHistory] {
        isLoadingHistory = true
        defer { isLoadingHistory = false }
        
        return try await networkService.fetchActivityHistory(userId: userId)
    }
}

// MARK: - Preview Helper
extension ActivityViewModel {
    static func preview() -> ActivityViewModel {
        let mockService = MockNetworkService()
        let viewModel = ActivityViewModel(networkService: mockService)
        
        // Презагружаем тестовые данные
        viewModel.statistics = UserStatistics(
            id: 1,
            userId: 1,
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
        
        return viewModel
    }
}