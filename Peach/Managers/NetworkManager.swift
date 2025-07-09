//
//  NetworkManager.swift
//  Peach
//
//  Created by Ildar Garifullin on 08.07.2025.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    func request<T: Codable>(endpoint: URLManager.EndPoint,
                             method: HTTPMethod = .get,
                             body: Data? = nil,
                             completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URLManager.shared.url(for: endpoint) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.noData))
                return
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.responseError(httpResponse.statusCode)))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(NetworkError.decodingError))
            }
        }
        task.resume()
    }
    
    func requestVoid(endpoint: URLManager.EndPoint,
                     method: HTTPMethod = .post,
                     body: Data? = nil,
                     completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URLManager.shared.url(for: endpoint) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.noData))
                return
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.responseError(httpResponse.statusCode)))
                return
            }
            completion(.success(()))
        }
        task.resume()
    }
    
    /// Отправка данных пользователя (SignIn) на сервер
    /// - Parameters:
    ///   - user: Модель пользователя для отправки
    ///   - completion: Замыкание с результатом выполнения
    func sendUserData(_ user: UserModel, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let userData = try JSONEncoder().encode(user)
            requestVoid(endpoint: .signIn, method: .post, body: userData, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }

    /// Получение профиля пользователя
    /// - Parameter completion: Замыкание с результатом ProfileModel или ошибкой
    func fetchProfile(completion: @escaping (Result<ProfileModel, Error>) -> Void) {
        request(endpoint: .profile, method: .get, body: nil, completion: completion)
    }

    /// Получение списка симптомов
    /// - Parameter completion: Замыкание с результатом массива SymptomModel или ошибкой
    func fetchSymptoms(completion: @escaping (Result<[SymptomModel], Error>) -> Void) {
        request(endpoint: .symptoms, method: .get, body: nil, completion: completion)
    }

    /// Получение истории чата
    /// - Parameter completion: Замыкание с результатом массива ChatMessageModel или ошибкой
    func fetchChatHistory(completion: @escaping (Result<[ChatMessageModel], Error>) -> Void) {
        request(endpoint: .chat, method: .get, body: nil, completion: completion)
    }

    /// Получение статуса премиум-подписки
    /// - Parameter completion: Замыкание с результатом PremiumStatusModel или ошибкой
    func fetchPremiumStatus(completion: @escaping (Result<PremiumStatusModel, Error>) -> Void) {
        request(endpoint: .premium, method: .get, body: nil, completion: completion)
    }

    /// Получение данных календаря
    /// - Parameter completion: Замыкание с результатом массива CalendarEventModel или ошибкой
    func fetchCalendarData(completion: @escaping (Result<[CalendarEventModel], Error>) -> Void) {
        request(endpoint: .calendar, method: .get, body: nil, completion: completion)
    }

    /// Получение данных онбординга
    /// - Parameter completion: Замыкание с результатом массива OnboardingModel или ошибкой
    func fetchOnboardingData(completion: @escaping (Result<[OnboardingModel], Error>) -> Void) {
        request(endpoint: .onboarding, method: .get, body: nil, completion: completion)
    }
}
