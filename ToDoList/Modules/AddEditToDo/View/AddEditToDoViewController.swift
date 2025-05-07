//
//  AddEditToDoViewController.swift
//  ToDoList
//
//  Created by Daniil Rassadin on 4/5/25.
//

import UIKit

@MainActor
protocol AddEditToDoViewProtocol: AnyObject {
    func displayTaskDetails(title: String?, date: Date?, text: String?)
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
        presenter.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.viewWillDisappear(
            title: contentView.titleTextField.text,
            text: contentView.textView.text
        )
    }
    
    // MARK: Configure Data
    
    func displayTaskDetails(title: String?, date: Date?, text: String?) {
        contentView.titleTextField.text = title
        contentView.dateLabel.text = date?.formatted(date: .numeric, time: .omitted)
        contentView.textView.text = text
    }

}
