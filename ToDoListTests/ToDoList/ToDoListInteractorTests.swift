//
//  ToDoListInteractorTests.swift
//  ToDoListTests
//
//  Created by Daniil Rassadin on 7/5/25.
//

import XCTest
@testable import ToDoList

final class ToDoListInteractorTests: XCTestCase {
    
    // MARK: Dependencies
    
    private var networkService: NetworkServiceSpy!
    private var userDefaultsManager: UserDefaultsManagerMock!
    private var storageManager: StorageManagerMock!
    private var presenter: ToDoListPresenterMock!
    private var interactor: ToDoListInteractor!
    
    // MARK: Tests Setup
    
    override func setUp() {
        super.setUp()
        networkService = NetworkServiceSpy()
        userDefaultsManager = UserDefaultsManagerMock()
        storageManager = StorageManagerMock()
        presenter = ToDoListPresenterMock()
        interactor = ToDoListInteractor(
            networkService: networkService,
            userDefaultsManager: userDefaultsManager,
            storageManger: storageManager,
            presenter: presenter
        )
    }
    
    override func tearDown() {
        interactor = nil
        presenter = nil
        storageManager = nil
        userDefaultsManager = nil
        networkService = nil
        super.tearDown()
    }
    
    // MARK: fetchToDos tests
    
    func testFetchToDos_callsStorageManager_whenNetworkServiceWasCalled() {
        userDefaultsManager.hasLoadedTodos = true
        
        interactor.fetchToDos()
        
        XCTAssertTrue(storageManager.fetchAllToDosWasCalled)
    }
    
    func testFetchToDos_loadsFromNetwork_whenFirstLaunchAndSuccess() {
        userDefaultsManager.hasLoadedTodos = false
        let expectation = XCTestExpectation(description: "Wait for network fetch")
        let expectedToDo = ToDo(id: UUID(), title: nil, text: nil, created: nil, completed: false)
        
        networkService.toDosResult = .success([expectedToDo])
        
        presenter.didFetchToDosHandler = { toDos in
            XCTAssertEqual(toDos.count, 1)
            expectation.fulfill()
        }

        interactor.fetchToDos()

        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(networkService.getToDosWasCalled)
        XCTAssertTrue(storageManager.saveToDosWasCalled)
        XCTAssertTrue(userDefaultsManager.hasLoadedTodos)
    }
    
    func testFetchToDos_sendsErrorFromNetwork_whenFirstLaunchAndFailure() {
        userDefaultsManager.hasLoadedTodos = false
        let expectation = XCTestExpectation(description: "Wait for network fetch")
        let expectedError = NetworkError.invalidResponse
        
        networkService.toDosResult = .failure(expectedError)
        
        presenter.didFetchToDosHandler = { toDos in
            XCTAssertEqual(toDos.count, 1)
            expectation.fulfill()
        }
        presenter.didFailToFetchToDosHandler = { error in
            XCTAssertTrue(error is NetworkError)
            expectation.fulfill()
        }

        interactor.fetchToDos()

        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(networkService.getToDosWasCalled)
    }
    
    func testSearchToDos_callsFetchMatchingWithQuery() {
        let expectation = XCTestExpectation(description: "Fetched matching todos")
        let expectedQuery = "test"
        
        storageManager.fetchToDosMatchingHandler = { query, completion in
            XCTAssertEqual(query, expectedQuery)
            completion([ToDo(id: UUID(), title: nil, text: nil, created: nil, completed: false)])
            expectation.fulfill()
        }
        
        interactor.searchToDos(with: expectedQuery)
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(presenter.didFetchToDosWasCalled)
    }
    
    func testMarkToDoAsCompleted_callsStorageUpdateToDoCompletion() {
        let expectedID = UUID()
        
        interactor.markToDoAsCompleted(withId: expectedID, completed: true)
        
        XCTAssertEqual(storageManager.capturedID, expectedID)
    }
    
    func testDeleteToDo_callsStorageDelete() {
        let expectedID = UUID()
        
        interactor.deleteToDo(withId: expectedID)
        
        XCTAssertEqual(storageManager.capturedID, expectedID)
    }

}
