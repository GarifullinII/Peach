//
//  OpenAIManager.swift
//  Peach
//
//  Created by Василий on 09.10.2023.
//

import Foundation
import OpenAISwift

final class OpenAIManager {

    // MARK: - Properties

    static let shared = OpenAIManager()

    private var client: OpenAISwift?

    // MARK: - Initializer

    private init() {}

    // MARK: - Instance methods

    func setup() {
        client = OpenAISwift(config: .makeDefaultOpenAI(apiKey: Config.openAIkey.rawValue))
    }

    func performRequest(input: String, completion: @escaping (Result<String, Error>) -> Void) {
        client?.sendCompletion(with: input, maxTokens: 1000) { response in
            switch response {
            case .success(let answer):
                completion(.success(answer.choices?.first?.text ?? ""))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
