//
//  UserDefaultsManager.swift
//  ToDoList
//
//  Created by Daniil Rassadin on 5/5/25.
//

import Foundation

protocol UserDefaultsManager: AnyObject {
    var hasLoadedTodos: Bool { get set }
}

final class DefaultUserDefaultsManager: UserDefaultsManager, @unchecked Sendable {
    
    static let shared = DefaultUserDefaultsManager()
    
    // MARK: Properties
    
    private let hasLoadedTodosKey = "hasLoadedTodos"
    
    var hasLoadedTodos: Bool {
        get {
            UserDefaults.standard.bool(forKey: hasLoadedTodosKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: hasLoadedTodosKey)
        }
    }
    
    // MARK: Initialization
    
    private init() {}
    
}
