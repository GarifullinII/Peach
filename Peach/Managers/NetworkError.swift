//
//  NetworkError.swift
//  Peach
//
//  Created by Ildar Garifullin on 08.07.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case responseError(Int)
    case decodingError
}
