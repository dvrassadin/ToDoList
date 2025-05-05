//
//  ToDoListViewController.swift
//  ToDoList
//
//  Created by Daniil Rassadin on 4/5/25.
//

import UIKit

@MainActor
protocol ToDoListViewProtocol: AnyObject {
    func displayToDos(_ toDos: [ToDo])
    func displayError(message: String)
    func showLoading()
    func hideLoading()
}

final class ToDoListViewController: UIViewController, ToDoListViewProtocol {
    
    // MARK: Properties
    
    var presenter: ToDoListPresenterProtocol!
    
    private lazy var contentView = ToDoListView()
    private lazy var dataSource: UITableViewDiffableDataSource<Int, ToDo> = makeDataSource()

    // MARK: Lifecycle
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    // MARK: Public Methods
    
    func displayToDos(_ toDos: [ToDo]) {
        self.applySnapshot(toDos: toDos)
    }
    
    func displayError(message: String) {
        // TODO: Implement error alert
    }
    
    func showLoading() {
        // TODO: Implement showing activity indicator
    }
    
    func hideLoading() {
        // TODO: Implement hiding activity indicator
    }
    
    // MARK: Diffable Data Source
    
    private func applySnapshot(toDos: [ToDo]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ToDo>()
        snapshot.appendSections([0])
        snapshot.appendItems(toDos)
        dataSource.apply(snapshot)
    }
    
    private func makeDataSource() -> UITableViewDiffableDataSource<Int, ToDo> {
        UITableViewDiffableDataSource<Int, ToDo>(
            tableView: contentView.tableView) { tableView, indexPath, toDo in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: ToDoTableViewCell.self.description(), for: indexPath
                ) as? ToDoTableViewCell
                
                cell?.setToDo(toDo)
                
                return cell
            }
    }

}
