//
//  ToDoListPresenter.swift
//  ToDoList
//
//  Created by Daniil Rassadin on 5/5/25.
//

import Foundation

protocol ToDoListPresenterProtocol: Sendable {
    func viewDidLoad()
    func didEnterSearchText(_ text: String?)
}

protocol ToDoListInteractorOutputProtocol: AnyObject, Sendable {
    func didFetchToDos(_ toDos: [ToDo])
    func didFailToFetchTodos(error: Error)
}

final class ToDoListPresenter: ToDoListPresenterProtocol, ToDoListInteractorOutputProtocol, @unchecked Sendable {
    
    // MARK: Properties
    
    var interactor: ToDoListInteractorInputProtocol!
    private weak var view: ToDoListViewProtocol?
    
    // MARK: Initialization
    
    init(view: ToDoListViewProtocol) {
        self.view = view
    }
    
    // MARK: ToDoListPresenterProtocol Methods
    
    func viewDidLoad() {
        Task { @MainActor in
            view?.showLoading()
        }
        interactor.fetchToDos()
    }
    
    func didEnterSearchText(_ text: String?) {
        interactor.searchToDos(with: text ?? "")
    }
    
    // MARK: ToDoListInteractorOutputProtocol Methods
    
    func didFetchToDos(_ toDos: [ToDo]) {
        Task { @MainActor in
            view?.displayToDos(toDos)
            view?.hideLoading()
        }
    }
    
    func didFailToFetchTodos(error: any Error) {
        Task { @MainActor in
            view?.displayError(message: error.localizedDescription)
            view?.hideLoading()
        }
    }
    
}
