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
    
    // MARK: UI Components
    
    private let searchController = UISearchController(searchResultsController: nil)

    // MARK: Lifecycle
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        presenter.viewDidLoad()
        contentView.tableView.delegate = self
    }
    
    // MARK: Public Methods
    
    func displayToDos(_ toDos: [ToDo]) {
        self.applySnapshot(toDos: toDos)
        contentView.countLabel.text = String(localized: "\(toDos.count) Задач")
    }
    
    func displayError(message: String) {
        // TODO: Implement error alert
    }
    
    func showLoading() {
        contentView.activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        contentView.activityIndicator.stopAnimating()
    }
    
    // MARK: Setup Navigation Bar
    
    private func setupNavigationBar() {
        navigationItem.title = String(localized: "Задачи")
        navigationItem.searchController = searchController
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        view.backgroundColor = .systemMint
        searchController.searchBar.searchTextField.backgroundColor = .Brand.gray
        searchController.searchBar.searchTextField.textColor = .Brand.white
        searchController.searchBar.searchTextField.tintColor = .Brand.white
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: String(localized: "Поиск"),
            attributes: [.foregroundColor: UIColor.Brand.white.withAlphaComponent(0.5)]
        )
        searchController.searchBar.searchTextField.rightViewMode = .always
        searchController.searchBar.searchTextField.rightView = view
        searchController.searchBar.searchTextField.leftView?.tintColor = .Brand.white.withAlphaComponent(0.5)
        searchController.searchBar.delegate = self
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
                cell?.separatorView.isHidden = indexPath.row == tableView.numberOfRows(
                    inSection: indexPath.section
                ) - 1
                
                return cell
            }
    }

}

// MARK: - UITableViewDelegate

extension ToDoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        guard let toDo = dataSource.itemIdentifier(for: indexPath) else { return nil }
        
        return UIContextMenuConfiguration {
            ToDoPreviewViewController(todo: toDo)
        } actionProvider: { _ in
            let edit = UIAction(
                title: String(localized: "Редактировать"),
                image: UIImage(systemName: "pencil")
            ) { _ in
                // TODO: Implement Add/Edit screen opening
            }
            
            let share = UIAction(
                title: String(localized: "Поделиться"),
                image: UIImage(systemName: "square.and.arrow.up"),
                attributes: .disabled // FIXME: Delete attribute after sharing implementation
            ) { _ in
                // TODO: Implement sharing
            }
            
            let delete = UIAction(
                title: String(localized: "Удалить"),
                image: UIImage(systemName: "trash"),
                attributes: .destructive
            ) { _ in
                self.presenter.didRequestDeleteToDo(
                    withID: toDo.id,
                    searchText: self.searchController.searchBar.text
                )
            }
            
            return UIMenu(children: [edit, share, delete])
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration,
        animator: UIContextMenuInteractionCommitAnimating
    ) {
        // TODO: Implement AddEditVC opening
//        animator.addCompletion {
//            if let previewVC = animator.previewViewController {
//                self.navigationController?.pushViewController(previewVC, animated: true)
//            }
//        }
    }
}

// MARK: - UISearchBarDelegate

extension ToDoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.didEnterSearchText(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.didCancelSearch()
    }
}
