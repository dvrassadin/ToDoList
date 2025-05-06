//
//  StorageManager.swift
//  ToDoList
//
//  Created by Daniil Rassadin on 6/5/25.
//

import Foundation

protocol StorageManager {
    @preconcurrency
    func saveToDo(_ toDo: ToDo)
    @preconcurrency
    func saveToDos(_ toDos: [ToDo])
    func fetchToDos(completion: @escaping @Sendable ([ToDo]) -> Void)
    func fetchToDos(matching query: String, completion: @escaping @Sendable ([ToDo]) -> Void)
    func deleteToDo(withID id: Int, completion: @escaping () -> Void)
}
