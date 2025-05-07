//
//  ToDoListPresenter.swift
//  ToDoList
//
//  Created by Daniil Rassadin on 5/5/25.
//

import Foundation

protocol ToDoListPresenterProtocol: Sendable {
    func viewDidLoad()
    func didTapCompleteButton(id: Int, completed: Bool, searchText: String)
    func didEnterSearchText(_ text: String?)
    func didCancelSearch()
    func didRequestDeleteToDo(withID id: Int, searchText: String?)
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
    
    func didTapCompleteButton(id: Int, completed: Bool, searchText: String) {
        interactor.markToDoAsCompleted(withId: id, completed: completed, searchText: searchText)
    }
    
    func didEnterSearchText(_ text: String?) {
        interactor.searchToDos(with: text ?? "")
    }
    
    func didCancelSearch() {
        interactor.fetchToDos()
    }
    
    func didRequestDeleteToDo(withID id: Int, searchText: String?) {
        interactor.deleteToDo(withId: id, searchText: searchText ?? "")
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
