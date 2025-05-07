//
//  StorageManager.swift
//  ToDoList
//
//  Created by Daniil Rassadin on 6/5/25.
//

import Foundation

protocol StorageManager {
    @preconcurrency
    func saveToDo(_ toDo: ToDo, completion: @escaping () -> Void)
    @preconcurrency
    func saveToDos(_ toDos: [ToDo])
    func updateToDoCompletion(id: Int, completed: Bool, completion: @escaping () -> Void)
    func fetchToDos(completion: @escaping @Sendable ([ToDo]) -> Void)
    func fetchToDos(matching query: String, completion: @escaping @Sendable ([ToDo]) -> Void)
    func fetchToDo(withID id: Int, completion: @escaping @Sendable (ToDo?) -> Void)
    func deleteToDo(withID id: Int, completion: @escaping () -> Void)
}
