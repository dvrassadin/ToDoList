# ToDo List App

A simple ToDo List application that allows users to add, edit, delete, and view tasks.

## Description

The app demonstrates the implementation of a task list with full CRUD operations (Create, Read, Update, Delete). On the first launch, data is fetched from a remote API ([dummyjson.com/todos](https://dummyjson.com/todos)) and then stored locally using Core Data for future use. All data operations are performed on background threads to ensure a responsive user interface.

## Features

* **View tasks:** Displays all tasks on the main screen, including title, optional description, creation date, and completion status.
* **Add new task:** Allows users to create a new task.
* **Edit task:** Modify details of an existing task.
* **Delete task:** Remove a task from the list.
* **Search tasks:** Filter tasks by keywords.
* **Persistent storage:** Data is stored locally and remains available between app launches.
* **Initial API loading:** Tasks are fetched from [dummyjson.com/todos](https://dummyjson.com/todos) on first launch.

## Architecture

The app is built using the **VIPER** architectural pattern (View, Interactor, Presenter, Entity, Router). Each module is clearly separated to enhance maintainability, scalability, and testability.

## Technologies and Frameworks

* **Language:** Swift 6
* **User Interface:** UIKit  
    * `UITableViewDiffableDataSource` for efficient list management.  
    * `UIContextMenuConfiguration` for contextual actions like edit or delete.
* **Data Storage:**  
    * Core Data: for local persistent storage.  
    * UserDefaults: for storing flags (e.g., first-time API load).
* **Networking:**  
    * URLSession: for making API requests to [dummyjson.com](https://dummyjson.com).
* **Concurrency:**  
    * Grand Central Dispatch (GCD): for handling background operations.
* **Localization:**  
    * String Catalog: for managing localized strings.
* **Testing:**  
    * XCTest: for writing unit tests for core components.

## Requirements

* **Xcode:** 15.0 or later  
* **iOS:** 16.0 or later
