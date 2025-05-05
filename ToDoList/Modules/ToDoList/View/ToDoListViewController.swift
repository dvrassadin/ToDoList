//
//  ToDoListViewController.swift
//  ToDoList
//
//  Created by Daniil Rassadin on 4/5/25.
//

import UIKit

protocol DefaultToDoListView: AnyObject {
    
}

final class ToDoListViewController: UIViewController {
    
    // MARK: Properties
    
    private lazy var contentView = ToDoListView()
    private lazy var dataSource = makeDataSource()

    // MARK: Lifecycle
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DummyJSONNetworkService.shared.getToDos { result in
            switch result {
            case .success(let toDos):
                DispatchQueue.main.async {
                    let toDos = toDos.todos.map { ToDo(apiToDo: $0) }
                    self.applySnapshot(toDos: toDos)
                }
            case .failure:
                break
            }
        }
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
