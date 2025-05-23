//
//  AddEditToDoInteractor.swift
//  ToDoList
//
//  Created by Daniil Rassadin on 7/5/25.
//

import Foundation

protocol AddEditToDoInteractorInputProtocol: Sendable {
    func fetchToDoForEditing(withId id: UUID)
    func saveToDo(_ toDo: ToDo)
}

final class AddEditToDoInteractor: AddEditToDoInteractorInputProtocol, @unchecked Sendable {
    
    // MARK: Properties
    
    private let storageManger: StorageManager
    
    private weak var presenter: AddEditToDoInteractorOutputProtocol?
    
    // MARK: Initialization
    
    init(storageManger: StorageManager, presenter: AddEditToDoInteractorOutputProtocol) {
        self.storageManger = storageManger
        self.presenter = presenter
    }
    
    // MARK: Public Methods
    
    func fetchToDoForEditing(withId id: UUID) {
        storageManger.fetchToDo(withID: id) { [weak self] toDo in
            self?.presenter?.didLoadToDoForEditing(toDo)
        }
    }
    
    func saveToDo(_ toDo: ToDo) {
        storageManger.saveToDo(toDo)
    }
    
}
