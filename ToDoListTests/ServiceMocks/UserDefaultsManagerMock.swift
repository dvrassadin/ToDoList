//
//  UserDefaultsManagerMock.swift
//  ToDoListTests
//
//  Created by Daniil Rassadin on 7/5/25.
//

import Foundation
@testable import ToDoList

final class UserDefaultsManagerMock: UserDefaultsManager {
    var hasLoadedTodos: Bool = false
}
