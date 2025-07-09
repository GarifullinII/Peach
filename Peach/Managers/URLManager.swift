//
//  URLManager.swift
//  Peach
//
//  Created by Ildar Garifullin on 09.07.2025.
//

import Foundation

final class URLManager {
    static let shared = URLManager()
    private init() {}
    
    enum EndPoint: String {
        case signIn = "/user"
        case profile = "/profile"
        case symptoms = "/symptoms"
        case chat = "/chat"
        case premium = "/premium"
        case calendar = "/calendar"
        case onboarding = "/onboarding"
    }
    
    private let baseURLString = "https://your-api-url.com"
    
    func url(for endpoint: EndPoint) -> URL? {
        return URL(string: baseURLString + endpoint.rawValue)
    }
}
