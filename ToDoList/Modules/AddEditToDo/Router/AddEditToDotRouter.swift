//
//  AddEditToDotRouter.swift
//  ToDoList
//
//  Created by Daniil Rassadin on 6/5/25.
//

import UIKit

@MainActor
protocol AddEditToDotRouterProtocol {
    static func createModule() -> UIViewController
}

final class AddEditToDotRouter: AddEditToDotRouterProtocol {
    
    static func createModule() -> UIViewController {
        let viewController = AddEditToDoViewController()
        
        return viewController
    }
    
}
