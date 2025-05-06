//
//  ToDoListRouter.swift
//  ToDoList
//
//  Created by Daniil Rassadin on 5/5/25.
//

import UIKit

@MainActor
protocol ToDoListRouterProtocol {
    static func createModule() -> UIViewController
}

final class ToDoListRouter: ToDoListRouterProtocol {
    
    static func createModule() -> UIViewController {
        let viewController = ToDoListViewController()
        
        let presenter = ToDoListPresenter(view: viewController)
        let networkService = DummyJSONNetworkService.shared
        let userDefaultsManager = DefaultUserDefaultsManager.shared
        let interactor = ToDoListInteractor(
            networkService: networkService,
            userDefaultsManager: userDefaultsManager,
            presenter: presenter
        )
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        
        return viewController
    }
    
}
