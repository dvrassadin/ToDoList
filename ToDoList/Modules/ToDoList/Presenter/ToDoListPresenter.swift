//
//  ToDoListPresenter.swift
//  ToDoList
//
//  Created by Daniil Rassadin on 5/5/25.
//

import Foundation

protocol ToDoListPresenterProtocol: Sendable {
    func viewDidLoad()
    func didTapAddToDo()
    func didSelectToDo(withID id: UUID)
    func didTapCompleteButton(id: UUID, completed: Bool)
    func didEnterSearchText(_ text: String?)
    func didCancelSearch()
    func didRequestDeleteToDo(withID id: UUID)
}

protocol ToDoListInteractorOutputProtocol: AnyObject, Sendable {
    func didFetchToDos(_ toDos: [ToDo])
    func didFailToFetchTodos(error: Error)
}

final class ToDoListPresenter: ToDoListPresenterProtocol, ToDoListInteractorOutputProtocol, @unchecked Sendable {
    
    // MARK: Properties
    
    private weak var view: ToDoListViewProtocol?
    var interactor: ToDoListInteractorInputProtocol!
    var router: ToDoListRouterProtocol!
    
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
    
    func didTapAddToDo() {
        Task { @MainActor in
            router.navigateToAddToDo()
        }
    }
    
    func didSelectToDo(withID id: UUID) {
        Task { @MainActor in
            router.navigateToEditToDo(withID: id)
        }
    }
    
    func didTapCompleteButton(id: UUID, completed: Bool) {
        interactor.markToDoAsCompleted(withId: id, completed: completed)
    }
    
    func didEnterSearchText(_ text: String?) {
        interactor.searchToDos(with: text ?? "")
    }
    
    func didCancelSearch() {
        interactor.fetchToDos()
    }
    
    func didRequestDeleteToDo(withID id: UUID) {
        interactor.deleteToDo(withId: id)
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
