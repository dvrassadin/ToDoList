//
//  StorageManager.swift
//  ToDoList
//
//  Created by Daniil Rassadin on 6/5/25.
//

import Foundation

protocol StorageManager {
    func saveToDo(_ toDo: ToDo)
    func saveToDos(_ toDos: [ToDo])
    func updateToDoCompletion(id: UUID, completed: Bool)
    func fetchToDos(completion: @escaping ([ToDo]) -> Void)
    func fetchToDos(matching query: String, completion: @escaping ([ToDo]) -> Void)
    func fetchToDo(withID id: UUID, completion: @escaping (ToDo?) -> Void)
    func deleteToDo(withID id: UUID)
}
