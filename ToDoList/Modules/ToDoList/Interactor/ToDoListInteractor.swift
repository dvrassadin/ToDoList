//
//  ToDoListInteractor.swift
//  ToDoList
//
//  Created by Daniil Rassadin on 5/5/25.
//

import Foundation

protocol ToDoListInteractorInputProtocol: Sendable {
    func fetchToDos()
    func searchToDos(with query: String)
    func deleteToDo(withId id: Int, searchText: String)
}

final class ToDoListInteractor: ToDoListInteractorInputProtocol, @unchecked Sendable {
    
    // MARK: Properties
    
    private let networkService: NetworkService
    private let userDefaultsManager: UserDefaultsManager
    private let storageManger: StorageManager
    
    private weak var presenter: ToDoListInteractorOutputProtocol?
    
    private let backgroundQueue = DispatchQueue.global(qos: .userInitiated)
    
    // MARK: Initialization
    
    init(
        networkService: NetworkService,
        userDefaultsManager: UserDefaultsManager,
        storageManger: StorageManager,
        presenter: ToDoListInteractorOutputProtocol
    ) {
        self.networkService = networkService
        self.userDefaultsManager = userDefaultsManager
        self.storageManger = storageManger
        self.presenter = presenter
    }
    
    // MARK: Public Methods
    
    func fetchToDos() {
        if !userDefaultsManager.hasLoadedTodos {
            backgroundQueue.async { [weak self] in
                guard let self else { return }
                
                networkService.getToDos { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success(let toDos):
                        presenter?.didFetchToDos(toDos)
                        storageManger.saveToDos(toDos)
                        userDefaultsManager.hasLoadedTodos = true
                    case .failure(let error):
                        presenter?.didFailToFetchTodos(error: error)
                    }
                }
            }
        } else {
            storageManger.fetchToDos { [weak self] toDos in
                self?.presenter?.didFetchToDos(toDos)
            }
        }
    }
    
    func searchToDos(with query: String) {
        storageManger.fetchToDos(matching: query) { [weak self] toDos in
            self?.presenter?.didFetchToDos(toDos)
        }
    }
    
    func deleteToDo(withId id: Int, searchText: String) {
        storageManger.deleteToDo(withID: id) { [weak self] in
            self?.storageManger.fetchToDos(matching: searchText) { [weak self] toDos in
                self?.presenter?.didFetchToDos(toDos)
            }
        }
    }
    
}
