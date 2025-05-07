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
    func markToDoAsCompleted(withId id: UUID, completed: Bool)
    func deleteToDo(withId id: UUID)
}

final class ToDoListInteractor: ToDoListInteractorInputProtocol, @unchecked Sendable {
    
    // MARK: Properties
    
    private let networkService: NetworkService
    private let userDefaultsManager: UserDefaultsManager
    private let storageManger: StorageManager
    
    private weak var presenter: ToDoListInteractorOutputProtocol?
    
    private let backgroundQueue = DispatchQueue.global(qos: .userInitiated)
    
    private var contextObserver: NSObjectProtocol?
    
    private var searchText: String?
    
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
        
        subscribeToNotifications()
    }
    
    deinit {
        if let contextObserver {
            NotificationCenter.default.removeObserver(contextObserver)
        }
    }
    
    // MARK: Public Methods
    
    func fetchToDos() {
        searchText = nil
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
        searchText = query
        storageManger.fetchToDos(matching: query) { [weak self] toDos in
            self?.presenter?.didFetchToDos(toDos)
        }
    }
    
    func markToDoAsCompleted(withId id: UUID, completed: Bool) {
        storageManger.updateToDoCompletion(id: id, completed: completed)
    }
    
    func deleteToDo(withId id: UUID) {
        storageManger.deleteToDo(withID: id)
    }
    
    // MARK: Private Methods
    
    private func subscribeToNotifications() {
        contextObserver = NotificationCenter.default.addObserver(
            forName: .NSManagedObjectContextDidSave,
            object: nil,
            queue: nil) { [weak self] _ in
                guard let self else { return }
                
                if let searchText {
                    searchToDos(with: searchText)
                } else {
                    fetchToDos()
                }
            }
    }
    
}
