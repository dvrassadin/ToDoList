//
//  ToDoListInteractor.swift
//  ToDoList
//
//  Created by Daniil Rassadin on 5/5/25.
//

import Foundation

protocol ToDoListInteractorInputProtocol: Sendable {
    func fetchTasks()
}

final class ToDoListInteractor: ToDoListInteractorInputProtocol, @unchecked Sendable {
    
    // MARK: Properties
    
    private let networkService: NetworkService
    
    private weak var presenter: ToDoListInteractorOutputProtocol?
    
    private let backgroundQueue = DispatchQueue.global(qos: .userInitiated)
    
    // MARK: Initialization
    
    init(networkService: NetworkService, presenter: ToDoListInteractorOutputProtocol) {
        self.networkService = networkService
        self.presenter = presenter
    }
    
    // MARK: Public Methods
    
    func fetchTasks() {
        backgroundQueue.async { [weak self] in
            guard let self else { return }
            
            networkService.getToDos { [weak self] result in
                switch result {
                case .success(let apiToDos):
                    let toDos = apiToDos.todos.map { ToDo(apiToDo: $0) }
                    self?.presenter?.didFetchToDos(toDos)
                case .failure(let error):
                    self?.presenter?.didFailToFetchTodos(error: error)
                }
            }
        }
    }
    
}
