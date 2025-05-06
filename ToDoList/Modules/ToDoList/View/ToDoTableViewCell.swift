//
//  ToDoTableViewCell.swift
//  ToDoList
//
//  Created by Daniil Rassadin on 5/5/25.
//

import UIKit

final class ToDoTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    private var toDoTopToTitleBottom: NSLayoutConstraint?
    private var toDoTopToContentTop: NSLayoutConstraint?
    private var dateTopToToDoBottom: NSLayoutConstraint?
    private var dateBottomToContentBottom: NSLayoutConstraint?
    private var toDoBottomToContentBottom: NSLayoutConstraint?

    // MARK: UI Components
    
    private let completeButton = UIButton(configuration: .plain())
    
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI Setup
    
    private func setupUI() {
        backgroundColor = .clear
        
        contentView.addSubview(completeButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(toDoLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(separatorView)
        
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        toDoLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        toDoTopToTitleBottom = toDoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6)
        toDoTopToContentTop = toDoLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12)
        dateTopToToDoBottom = dateLabel.topAnchor.constraint(equalTo: toDoLabel.bottomAnchor, constant: 6)
        dateBottomToContentBottom = dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        toDoBottomToContentBottom = toDoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        
        NSLayoutConstraint.activate([
            completeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            completeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            completeButton.heightAnchor.constraint(equalToConstant: 24),
            completeButton.widthAnchor.constraint(equalTo: completeButton.heightAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: completeButton.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            toDoLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            toDoLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            dateLabel.leadingAnchor.constraint(equalTo: toDoLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: toDoLabel.trailingAnchor),
            
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    // MARK: Configure Data
    
    func setToDo(_ toDo: ToDo) {
        if toDo.completed {
            completeButton.configuration?.image = UIImage(systemName: "circle")
            completeButton.configuration?.baseForegroundColor = .Brand.stroke
        } else {
            completeButton.configuration?.image = UIImage(systemName: "checkmark.circle")
            completeButton.configuration?.baseForegroundColor = .Brand.yellow
        }
        
        if let title = toDo.title {
            toDoTopToTitleBottom?.isActive = true
            titleLabel.layer.opacity = toDo.completed ? 0.5 : 1
            if toDo.completed {
                titleLabel.attributedText = NSAttributedString(string: title)
            } else {
                titleLabel.attributedText = NSAttributedString(
                    string: title,
                    attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
                )
            }
        } else {
            toDoTopToContentTop?.isActive = true
        }
        
        toDoLabel.text = toDo.text
        toDoLabel.layer.opacity = toDo.completed ? 0.5 : 1
        
        if let date = toDo.created {
            dateLabel.text = date.formatted(date: .numeric, time: .omitted)
            dateBottomToContentBottom?.isActive = true
        } else {
            toDoBottomToContentBottom?.isActive = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        toDoTopToTitleBottom?.isActive = false
        toDoTopToContentTop?.isActive = false
        dateTopToToDoBottom?.isActive = false
        dateBottomToContentBottom?.isActive = false
        toDoBottomToContentBottom?.isActive = false
        
        completeButton.configuration?.image = nil
        titleLabel.attributedText = nil
        titleLabel.layer.opacity = 1
        toDoLabel.text = nil
        toDoLabel.layer.opacity = 1
        dateLabel.text = nil
        separatorView.isHidden = false
    }
    
}
