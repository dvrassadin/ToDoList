//
//  ToDoTableViewCell.swift
//  ToDoList
//
//  Created by Daniil Rassadin on 5/5/25.
//

import UIKit

@MainActor
protocol ToDoTableViewCellDelegate: AnyObject {
    func toggleCompleted(toDo: ToDo)
}

final class ToDoTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    private weak var delegate: ToDoTableViewCellDelegate?
    
    private var toDo: ToDo?

    // MARK: UI Components
    
    private let completeButton = UIButton(configuration: .plain())
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        return stackView
    }()
    
    private let titleLabel: UILabel = {
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
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .Brand.white
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.layer.opacity = 0.5
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .Brand.stroke
        return view
    }()
    
    // MARK: Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupUserInteraction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI Setup
    
    private func setupUI() {
        backgroundColor = .Brand.black
        selectionStyle = .none
        
        contentView.addSubview(completeButton)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(toDoLabel)
        stackView.addArrangedSubview(dateLabel)
        contentView.addSubview(separatorView)
        
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            completeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            completeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            completeButton.heightAnchor.constraint(equalToConstant: 24),
            completeButton.widthAnchor.constraint(equalTo: completeButton.heightAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: completeButton.trailingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    // MARK: Configure Data
    
    func setToDo(_ toDo: ToDo, delegate: ToDoTableViewCellDelegate) {
        self.toDo = toDo
        self.delegate = delegate
        
        if toDo.completed {
            completeButton.configuration?.image = UIImage(systemName: "checkmark.circle")
            completeButton.configuration?.baseForegroundColor = .Brand.yellow
        } else {
            completeButton.configuration?.image = UIImage(systemName: "circle")
            completeButton.configuration?.baseForegroundColor = .Brand.stroke
        }
        
        if let title = toDo.title, !title.isEmpty {
            titleLabel.layer.opacity = toDo.completed ? 0.5 : 1
            if toDo.completed {
                titleLabel.attributedText = NSAttributedString(
                    string: title,
                    attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
                )
            } else {
                titleLabel.attributedText = NSAttributedString(string: title)
            }
            titleLabel.isHidden = false
        } else {
            titleLabel.isHidden = true
        }
        
        if let text = toDo.text, !text.isEmpty {
            toDoLabel.text = toDo.text
            toDoLabel.layer.opacity = toDo.completed ? 0.5 : 1
            toDoLabel.isHidden = false
        } else {
            toDoLabel.isHidden = true
        }
        
        if let date = toDo.created {
            dateLabel.text = date.formatted(date: .numeric, time: .omitted)
            dateLabel.isHidden = false
        } else {
            dateLabel.isHidden = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        completeButton.configuration?.image = nil
        titleLabel.attributedText = nil
        titleLabel.layer.opacity = 1
        toDoLabel.text = nil
        toDoLabel.layer.opacity = 1
        dateLabel.text = nil
        separatorView.isHidden = false
    }
    
    // MARK: Setup User Interaction
    
    private func setupUserInteraction() {
        completeButton.addAction(UIAction { [weak self] _ in
            guard let self, let toDo else { return }
            
            delegate?.toggleCompleted(toDo: toDo)
        }, for: .touchUpInside)
    }
    
}
