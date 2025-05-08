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
    private var interactor: ToDoListInteractorMock!
    private var router: ToDoListRouterMock!
    private var presenter: ToDoListPresenter!
    
    // MARK: Tests Setup
    
    @MainActor
    override func setUp() {
        viewController = ToDoListViewMock()
        interactor = ToDoListInteractorMock()
        router = ToDoListRouterMock()
        presenter = ToDoListPresenter(view: viewController)
        presenter.interactor = interactor
        presenter.router = router
    }
    
    override func tearDown() {
        viewController = nil
        interactor = nil
        router = nil
        presenter = nil
        super.tearDown()
    }
    
    // MARK: View Did Load Tests
    
    @MainActor
    func testViewDidLoad_callsShowLoading() {
        let expectation = expectation(description: "showLoading called")

        viewController.showLoadingHandler = {
            expectation.fulfill()
        }
        
        presenter.viewDidLoad()
        
        wait(for: [expectation], timeout: 1)
        XCTAssertTrue(viewController.showLoadingWasCalled)
    }
    
    func testViewDidLoad_callsInteractorFetchToDos() {
        presenter.viewDidLoad()
        
        XCTAssertTrue(interactor.fetchToDosWasCalled)
    }
    
    // MARK: Did Tap Add Task Tests
    
    @MainActor
    func testDidTapAddTask_callsRouterNavigateToAddToDo() {
        let expectation = expectation(description: "navigateToAddToDo called")
        
        router.navigateToAddToDoHandler = {
            expectation.fulfill()
        }
        
        presenter.didTapAddToDo()
        
        wait(for: [expectation])
        XCTAssertTrue(router.navigateToAddToDoWasCalled)
    }
    
    // MARK: Did Select ToDo Tests
    
    @MainActor
    func testDidSelectToDo_callsRouterNavigateToAddToDo() {
        let expectation = expectation(description: "navigateToEditToDo called")
        let expectedID = UUID()
        
        router.navigateToEditToDoHandler = { id in
            XCTAssertEqual(id, expectedID)
            expectation.fulfill()
        }
        
        presenter.didSelectToDo(withID: expectedID)
        
        wait(for: [expectation], timeout: 1)
    }
    
    // MARK: Did Tap Complete Button Tests
    
    func testDidTapCompleteButton_callsInteractorMarkToDoAsCompleted() {
        let expectedID = UUID()
        
        presenter.didTapCompleteButton(id: expectedID, completed: true)
        
        XCTAssertEqual(interactor.capturedUUID, expectedID)
    }
    
    // MARK: Did Enter Search Text Tests
    
    func testDidEnterSearchText_callsInteractorSearchToDos() {
        let expectedSearchText = "test"
        
        presenter.didEnterSearchText(expectedSearchText)
        
        XCTAssertEqual(interactor.capturedString, expectedSearchText)
    }
    
    // MARK: Did Cancel Search Tests
    
    func testDidCancelSearch_callsInteractorFetchToDos() {
        presenter.didCancelSearch()
        
        XCTAssertTrue(interactor.fetchToDosWasCalled)
    }
    
    // MARK: Did Request Delete ToDo Tests
    
    func testDidRequestDeleteToDo_callsInteractorDeleteToDo() {
        let expectedID = UUID()
        
        presenter.didRequestDeleteToDo(withID: expectedID)
        
        XCTAssertEqual(interactor.capturedUUID, expectedID)
    }
    
    // MARK: Did Fetch ToDos Tests
    
    @MainActor
    func testDidFetchToDos_callsViewDisplayToDosAndHideLoading() {
        let expectation = expectation(description: "displayToDos called")
        let expectedToDo = ToDo(id: UUID(), title: nil, text: nil, created: nil, completed: false)
        
        viewController.displayToDosHandler = { toDos in
            XCTAssertEqual(toDos.first, expectedToDo)
            expectation.fulfill()
        }
        
        presenter.didFetchToDos([expectedToDo])
        wait(for: [expectation], timeout: 1)
        
        XCTAssertTrue(viewController.hideLoadingWasCalled)
    }
    
    // MARK: Did Fail To Fetch Todos Tests
    
    @MainActor
    func testDidFailToFetchTodos_callsViewDisplayErrorAndHideLoading() {
        let expectation = expectation(description: "displayError called")
        
        viewController.displayErrorHandler = { _ in
            expectation.fulfill()
        }
        
        presenter.didFailToFetchTodos(error: NetworkError.invalidResponse)
        wait(for: [expectation], timeout: 1)
        
        XCTAssertTrue(viewController.hideLoadingWasCalled)
    }
    
}
