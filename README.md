# FitnessApp - MVVM iOS Application

Фитнес-трекер, реализованный с использованием MVVM-паттерна для курсовой работы по iOS-разработке.

## Особенности
- MVVM архитектура с SwiftUI
- Клиент-серверное взаимодействие (mock API)
- Async/await для асинхронных операций
- Комплексная обработка состояний (loading/error/success)
- Pull-to-refresh функциональность

## Структура проекта
- `Models/` - модели данных
- `Services/` - сетевые сервисы
- `ViewModels/` - бизнес-логика MVVM
- `TabView/` - пользовательский интерфейс

## Технологии
- SwiftUI
- Combine Framework
- Modern Swift Concurrency (async/await)
- Foundation URLSession

## Как запустить
1. Склонируйте репозиторий
2. Откройте NavigationTesting.xcodeproj в Xcode
3. Запустите на симуляторе iOS 15.0+
