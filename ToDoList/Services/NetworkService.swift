//
//  NetworkService.swift
//  ToDoList
//
//  Created by Daniil Rassadin on 4/5/25.
//

import OSLog

protocol NetworkService: Sendable {
    func getToDos(completion: @escaping @Sendable (Result<[ToDo], NetworkError>) -> Void)
}

final class DummyJSONNetworkService: NetworkService {
    
    static let shared: NetworkService = DummyJSONNetworkService()
    
    // MARK: Properties
    
    private let session: URLSession = {
        let session = URLSession(configuration: .default)
        session.configuration.timeoutIntervalForRequest = 10
        return session
    }()
    
    private let decoder = JSONDecoder()
    
    private let baseURL: URL = {
        guard let url = URL(string: "https://dummyjson.com/") else {
            fatalError("Invalid base URL")
        }
        return url
    }()
    
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "",
        category: "Networking"
    )
    
    // MARK: Initialization
    
    private init() {}
    
    // MARK: Public Methods
    
    func getToDos(completion: @escaping @Sendable (Result<[ToDo], NetworkError>) -> Void) {
        let url = baseURL.appendingPathComponent("todos")
        
        logger.info("Starting request: \(url.absoluteString)")
        session.dataTask(with: url) { [weak self] data, response, error in
            guard let self else { return }
            if let error {
                logger.error("Error: \"\(error)\" for request: \(url.absoluteString)")
                completion(.failure(.unknown(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                logger.error("Invalid response type received.")
                completion(.failure(.invalidResponse))
                return
            }
            
            guard 200..<300 ~= httpResponse.statusCode else {
                logger.error("Received non-success status code: \(httpResponse.statusCode)")
                completion(.failure(.badStatusCode(httpResponse.statusCode)))
                return
            }
            
            guard let data else {
                logger.error("No data received without any error.")
                completion(.failure(.noData))
                return
            }
            
            do {
                let apiToDos = try self.decoder.decode(APIToDos.self, from: data)
                logger.info("Received \(apiToDos.todos.count) to-do items for request: \(url.absoluteString)")
                let domainToDos = apiToDos.todos.map { ToDo(apiToDo: $0) }
                completion(.success(domainToDos))
            } catch {
                logger.error("Failed to decode JSON for request: \(url.absoluteString)")
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
    
}
