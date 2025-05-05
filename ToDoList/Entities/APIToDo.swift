//
//  APIToDo.swift
//  ToDoList
//
//  Created by Daniil Rassadin on 4/5/25.
//

import Foundation

struct APIToDos: Decodable {
    let todos: [Self.ToDo]
    
    struct ToDo: Decodable {
        let id: Int
        let todo: String
        let completed: Bool
    }
}
