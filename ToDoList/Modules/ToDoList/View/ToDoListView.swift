//
//  ToDoListView.swift
//  ToDoList
//
//  Created by Daniil Rassadin on 4/5/25.
//

import UIKit

final class ToDoListView: UIView {
    
    // MARK: UI Components
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            ToDoTableViewCell.self,
            forCellReuseIdentifier: ToDoTableViewCell.self.description()
        )
        tableView.backgroundColor = .Brand.black
        return tableView
    }()
    
    // MARK: Initialization
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI Setup

    private func setupUI() {
        addSubview(tableView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
