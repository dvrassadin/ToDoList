//
//  ToDoTableViewCell.swift
//  ToDoList
//
//  Created by Daniil Rassadin on 5/5/25.
//

import UIKit

final class ToDoTableViewCell: UITableViewCell {

    // MARK: UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .Brand.white
        return label
    }()
    
    private let toDoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .Brand.white
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .Brand.white
        label.layer.opacity = 0.5
        return label
    }()
    
    // MARK: Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI Setup
    
    private func setupUI() {
        backgroundColor = .clear
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(toDoLabel)
        contentView.addSubview(dateLabel)
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        toDoLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            toDoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            toDoLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            toDoLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: toDoLabel.bottomAnchor, constant: 6),
            dateLabel.leadingAnchor.constraint(equalTo: toDoLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: toDoLabel.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: Configure Data
    
    func setToDo(_ toDo: ToDo) {
        if let title = toDo.title {
            titleLabel.layer.opacity = toDo.completed ? 0.5 : 1
            if toDo.completed {
                titleLabel.attributedText = NSAttributedString(string: title)
            } else {
                titleLabel.attributedText = NSAttributedString(
                    string: title,
                    attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
                )
            }
        }
        toDoLabel.text = toDo.text
        toDoLabel.layer.opacity = toDo.completed ? 0.5 : 1
        dateLabel.text = toDo.created?.formatted(date: .numeric, time: .omitted)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.attributedText = nil
        titleLabel.layer.opacity = 1
        toDoLabel.text = nil
        toDoLabel.layer.opacity = 1
        dateLabel.text = nil
    }
    
}
