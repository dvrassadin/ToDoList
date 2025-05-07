//
//  ToDo.swift
//  ToDoList
//
//  Created by Daniil Rassadin on 4/5/25.
//

import Foundation

struct ToDo: Hashable {
    let id: UUID
    let title: String?
    let text: String?
    let created: Date?
    var completed: Bool
    
    init(id: UUID, title: String?, text: String?, created: Date?, completed: Bool) {
        self.id = id
        self.title = title
        self.text = text
        self.created = created
        self.completed = completed
    }
    
    init(apiToDo: APIToDos.ToDo) {
        self.id = UUID()
        self.title = nil
        self.text = apiToDo.todo
        self.created = nil
        self.completed = apiToDo.completed
    }
}
