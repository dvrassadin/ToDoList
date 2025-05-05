//
//  AddEditTaskViewController.swift
//  ToDoList
//
//  Created by Daniil Rassadin on 4/5/25.
//

import UIKit

final class AddEditTaskViewController: UIViewController {
    
    // MARK: Properties
    
    private lazy var contentView = AddEditTaskView()
    
    // MARK: Lifecycle
    
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
