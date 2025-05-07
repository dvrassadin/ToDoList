//
//  AddEditToDotRouter.swift
//  ToDoList
//
//  Created by Daniil Rassadin on 6/5/25.
//

import UIKit

@MainActor
protocol AddEditToDotRouterProtocol {
    
}

final class AddEditToDotRouter: AddEditToDotRouterProtocol, @unchecked Sendable {
    
    // MARK: Properties
    
    weak var viewController: UIViewController?
    
    // MARK: Crate Module
    
    static func createModule(toDoID: UUID? = nil) -> UIViewController {
        let viewController = AddEditToDoViewController()
        
        let presenter = AddEditToDoPresenter(view: viewController, toDoID: toDoID)
        let storageManage = CoreDataStack.shared
        let interactor = AddEditToDoInteractor(storageManger: storageManage, presenter: presenter)
        let router = AddEditToDotRouter()
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
        router.viewController = viewController
        
        return viewController
    }
    
}
