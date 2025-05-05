//
//  NetworkError.swift
//  ToDoList
//
//  Created by Daniil Rassadin on 5/5/25.
//

import Foundation

enum NetworkError: Error, Sendable {
    case invalidResponse
    case badStatusCode(Int)
    case noData
    case decodingError(Error)
    case unknown(Error? = nil)
}
