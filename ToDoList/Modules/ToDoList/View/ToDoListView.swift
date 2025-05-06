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
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .Brand.white
        return activityIndicator
    }()
    
    private let bottomPanel: UIView = {
        let view = UIView()
        view.backgroundColor = .Brand.gray
        return view
    }()
    
    private let bottomPanelTopLine: UIView = {
        let view = UIView()
        view.backgroundColor = .Brand.stroke
        return view
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .Brand.white
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    let addToDoButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "square.and.pencil")
        configuration.baseForegroundColor = .Brand.yellow
        return UIButton(configuration: configuration)
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
        addSubview(activityIndicator)
        addSubview(bottomPanel)
        bottomPanel.addSubview(bottomPanelTopLine)
        bottomPanel.addSubview(countLabel)
        bottomPanel.addSubview(addToDoButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        bottomPanel.translatesAutoresizingMaskIntoConstraints = false
        bottomPanelTopLine.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        addToDoButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomPanel.topAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            bottomPanel.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomPanel.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomPanel.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomPanel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -49),
            
            bottomPanelTopLine.topAnchor.constraint(equalTo: bottomPanel.topAnchor),
            bottomPanelTopLine.leadingAnchor.constraint(equalTo: bottomPanel.leadingAnchor),
            bottomPanelTopLine.trailingAnchor.constraint(equalTo: bottomPanel.trailingAnchor),
            bottomPanelTopLine.heightAnchor.constraint(equalToConstant: 0.33),
            
            countLabel.topAnchor.constraint(equalTo: bottomPanel.topAnchor, constant: 20.5),
            countLabel.centerXAnchor.constraint(equalTo: bottomPanel.centerXAnchor),
            countLabel.leadingAnchor.constraint(greaterThanOrEqualTo: bottomPanel.leadingAnchor, constant: 16),
            countLabel.trailingAnchor.constraint(lessThanOrEqualTo: bottomPanel.trailingAnchor, constant: -16),
            countLabel.trailingAnchor.constraint(equalTo: addToDoButton.leadingAnchor, constant: -16),
            
            addToDoButton.topAnchor.constraint(equalTo: bottomPanelTopLine.bottomAnchor, constant: 13),
            addToDoButton.trailingAnchor.constraint(equalTo: bottomPanel.trailingAnchor, constant: -20.66),
            addToDoButton.heightAnchor.constraint(equalToConstant: 28),
            addToDoButton.widthAnchor.constraint(equalTo: addToDoButton.heightAnchor)
        ])
    }
    
}
