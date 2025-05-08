//
//  ToDoListPresenterTests.swift
//  ToDoListTests
//
//  Created by Daniil Rassadin on 7/5/25.
//

import XCTest
@testable import ToDoList

final class ToDoListPresenterTests: XCTestCase {
    
    // MARK: Dependencies
    
    private var viewController: ToDoListViewMock!
    private var router: ToDoListRouterMock!
    private var presenter: ToDoListPresenter!
    
    // MARK: Tests Setup
    
    @MainActor
    override func setUp() {
        viewController = ToDoListViewMock()
        router = ToDoListRouterMock()
        presenter = ToDoListPresenter(view: viewController)
        presenter.router = router
    }
    
}
