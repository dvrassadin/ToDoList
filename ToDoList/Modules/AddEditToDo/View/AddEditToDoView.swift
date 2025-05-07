//
//  AddEditToDoView.swift
//  ToDoList
//
//  Created by Daniil Rassadin on 4/5/25.
//

import UIKit

final class AddEditToDoView: UIView {

    // MARK: UI Components
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .Brand.white
        textField.font = .systemFont(ofSize: 34, weight: .bold)
        textField.attributedPlaceholder = NSAttributedString(
            string: String(localized: "Заголовок"),
            attributes: [
                .font: UIFont.systemFont(ofSize: 34, weight: .bold),
                .foregroundColor: UIColor.white.withAlphaComponent(0.5)
            ]
        )
        return textField
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white.withAlphaComponent(0.5)
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.textColor = .Brand.white
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        textView.backgroundColor = .clear
        return textView
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
        backgroundColor = .Brand.black
        
        addSubview(titleTextField)
        addSubview(dateLabel)
        addSubview(textView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            titleTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            dateLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            
            textView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}
