//
//  ToDoListRouter.swift
//  ToDoList
//
//  Created by Daniil Rassadin on 5/5/25.
//

import UIKit

@MainActor
protocol ToDoListRouterProtocol {
    func navigateToAddToDo()
    func navigateToEditToDo(withID id: Int)
}

final class ToDoListRouter: ToDoListRouterProtocol {
    
    // MARK: Properties
    
    weak var viewController: UIViewController?
    
    // MARK: Create Module
    
    static func createModule() -> UIViewController {
        let viewController = ToDoListViewController()
        
        let presenter = ToDoListPresenter(view: viewController)
        let networkService = DummyJSONNetworkService.shared
        let userDefaultsManager = DefaultUserDefaultsManager.shared
        let storageManager = CoreDataStack.shared
        let interactor = ToDoListInteractor(
            networkService: networkService,
            userDefaultsManager: userDefaultsManager,
            storageManger: storageManager,
            presenter: presenter
        )
        let router = ToDoListRouter()
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
        router.viewController = viewController
        
        return viewController
    }
    
    // MARK: Navigation
    
    func navigateToAddToDo() {
        let addEditViewController = AddEditToDotRouter.createModule()
        viewController?.navigationController?.pushViewController(
            addEditViewController,
            animated: true
        )
    }
    
    func navigateToEditToDo(withID id: Int) {
        let addEditViewController = AddEditToDotRouter.createModule(toDoID: id)
        viewController?.navigationController?.pushViewController(
            addEditViewController,
            animated: true
        )
    }
    
}
