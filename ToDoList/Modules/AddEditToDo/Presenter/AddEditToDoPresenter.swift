//
//  AddEditToDoPresenter.swift
//  ToDoList
//
//  Created by Daniil Rassadin on 6/5/25.
//

import Foundation

protocol AddEditToDoPresenterProtocol: Sendable {
    func viewDidLoad()
    func viewWillDisappear(title: String?, text: String?)
}

protocol AddEditToDoInteractorOutputProtocol: AnyObject {
    func didLoadToDoForEditing(_ toDo: ToDo?)
}

final class AddEditToDoPresenter: AddEditToDoPresenterProtocol, AddEditToDoInteractorOutputProtocol, @unchecked Sendable {
    
    // MARK: Properties
    
    private weak var view: AddEditToDoViewProtocol?
    var interactor: AddEditToDoInteractorInputProtocol!
    var router: AddEditToDotRouterProtocol!
    
    private let toDoID: UUID?
    private var toDo: ToDo?
    
    // MARK: Initialization
    
    init(view: AddEditToDoViewProtocol, toDoID: UUID?) {
        self.view = view
        self.toDoID = toDoID
    }
    
    // MARK: AddEditToDoPresenterProtocol Methods
    
    func viewDidLoad() {
        if let toDoID {
            interactor.fetchToDoForEditing(withId: toDoID)
        } else {
            Task { @MainActor in
                view?.displayTaskDetails(title: nil, date: .now, text: nil)                
            }
        }
    }
    
    func viewWillDisappear(title: String?, text: String?) {
        if toDoID == nil {
            
        } else if let toDo, title != toDo.title || text != toDo.text {
            let updatedToDo = ToDo(
                id: toDo.id,
                title: title,
                text: text,
                created: toDo.created,
                completed: toDo.completed
            )
            interactor.updateToDo(updatedToDo)
        }
    }
    
    // MARK: AddEditToDoInteractorOutputProtocol Methods
    
    func didLoadToDoForEditing(_ toDo: ToDo?) {
        self.toDo = toDo
        Task { @MainActor in
            view?.displayTaskDetails(title: toDo?.title, date: toDo?.created, text: toDo?.text)
        }
    }
    
}
