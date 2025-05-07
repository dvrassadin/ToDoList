//
//  AddEditToDoViewController.swift
//  ToDoList
//
//  Created by Daniil Rassadin on 4/5/25.
//

import UIKit

@MainActor
protocol AddEditToDoViewProtocol: AnyObject {
    
}

final class AddEditToDoViewController: UIViewController, AddEditToDoViewProtocol {
    
    // MARK: Properties
    
    var presenter: AddEditToDoPresenterProtocol!
    
    private lazy var contentView = AddEditToDoView()
    
    // MARK: Lifecycle
    
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
