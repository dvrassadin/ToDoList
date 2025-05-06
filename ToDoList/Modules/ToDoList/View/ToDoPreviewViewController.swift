//
//  ToDoPreviewViewController.swift
//  ToDoList
//
//  Created by Daniil Rassadin on 6/5/25.
//

import UIKit

final class ToDoPreviewViewController: UIViewController {
    
    // MARK: Properties

    private let toDo: ToDo
    
    // MARK: UI Components
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .Brand.white
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let toDoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .Brand.white
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .Brand.white
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.layer.opacity = 0.5
        return label
    }()

    // MARK: Lifecycle
    
    init(todo: ToDo) {
        self.toDo = todo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        setToDo()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let targetSize = CGSize(width: 320, height: UIView.layoutFittingCompressedSize.height)
        preferredContentSize = view.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
    
    // MARK: UI Setup
    
    private func setupUI() {
        view.backgroundColor = .Brand.gray
        view.layer.cornerRadius = 12
        
        if let title = toDo.title, !title.isEmpty {
            view.addSubview(titleLabel)
        }
        view.addSubview(toDoLabel)
        if toDo.created != nil {
            view.addSubview(dateLabel)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        toDoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            toDoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            toDoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        if let title = toDo.title, !title.isEmpty {
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
                titleLabel.leadingAnchor.constraint(equalTo: toDoLabel.leadingAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: toDoLabel.trailingAnchor),
                
                toDoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6)
            ])
        } else {
            toDoLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
        }
        
        if toDo.created != nil {
            dateLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                dateLabel.topAnchor.constraint(equalTo: toDoLabel.bottomAnchor, constant: 6),
                dateLabel.leadingAnchor.constraint(equalTo: toDoLabel.leadingAnchor),
                dateLabel.trailingAnchor.constraint(equalTo: toDoLabel.trailingAnchor),
                dateLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12)
            ])
        } else {
            toDoLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12).isActive = true
        }
    }
    
    // MARK: Configure Data
    
    private func setToDo() {
        if let title = toDo.title, !title.isEmpty {
            titleLabel.text = title
        }
        toDoLabel.text = toDo.text
        if let created = toDo.created {
            dateLabel.text = created.formatted(date: .numeric, time: .omitted)
        }
    }

}
