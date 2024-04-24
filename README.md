# GetirFinalCase

## Table of Contents
- [General Info and App Screen](#general-info)
- [Technologies](#technologies)
- [Features](#features)
- [Design Pattern](#design-pattern)
- [Dependencies](#dependencies)
- [Setup](#setup)


## General Info and App Screen
This is an iOS Project using Programlamatic UIKit for Getir iOS Bootcamp. It features a two-page layout displaying products and banners, along with a detailed product page.
- **First Screen**: Utilizes a compositional layout to display a collection of products. It's divided into two sections: recommended products and a comprehensive product list, each offering a dynamic user experience.
- **Second Screen**: Provides detailed information about the products, including total price visualization and an interactive basket where users can add products.
- **Third Screen**: A cart page where users can review all items added to the basket, implemented with a compositional layout to enhance usability.


![Screens](https://github.com/elifilaykandemir/GetirFinalCase/blob/main/GetirScreens.png)

## Technologies
Project is created with:
- Swift Language version: 5
- Swift Package Manager
- Programmatic UIKit
- Xcode Version Version 15.0 (15A240d)

## Features

The architecture of the application includes the use of Singleton pattern for managing certain core functionalities such as the Stepper and the Basket. Singleton instances ensure that these components have a global point of access while maintaining a single source of truth throughout the app lifecycle.

- **Stepper Manager**: Manages the step count interactions across the application. This manager class is responsible for incrementing, decrementing, and providing the current step value used throughout various screens in the app.

- **Basket Manager**: Handles all operations related to the shopping basket, such as adding, removing, and updating items. The Basket Manager is implemented as a Singleton to maintain consistency and state across the application. It uses notifications to broadcast updates to different parts of the application, allowing for a reactive and synchronized update mechanism.

- **Notifications**:Notification Center is utilized to broadcast messages within the application. This allows for a loose coupling between the Basket Manager and the components interested in basket updates. Observers are added in relevant screens to listen for changes, making it possible to update the UI in response to basket modifications without tight integration.

- **Unit Testing**: Unit tests have been written for the Basket Manager to ensure its reliability and to adhere to the principle of Test-Driven Development (TDD). The tests cover various scenarios, including adding items to the basket, removing items, and checking the total amount, to validate that the Basket Manager behaves as expected under different conditions.

## Design Pattern
The project leverages the VIPER design pattern, an architecture that enhances testability and separation of concerns. By adopting VIPER, each component of the application - View, Interactor, Presenter, Entity, and Routing - plays its role cohesively to create a maintainable and scalable structure. This pattern facilitated the modular development of the application, enabling each team member to focus on their respective area without causing disruptions to the others. The clear boundaries set by VIPER allow for better code reuse and unit testing, which contributed significantly to the robustness of the application.

## Dependencies
The project uses the following dependencies:

- **Kingfisher**: This powerful, pure-Swift library is perfect for downloading and caching images from the web. It simplifies the task of fetching images asynchronously and storing them in a cache for quick access, enhancing the performance and responsiveness of the application.


## Setup
Setting up the project is straightforward thanks to Swift Package Manager. There's no need for manual downloads or dependency management scripts.

Upon cloning the repository and opening the project in Xcode, Swift Package Manager will automatically download Kingfisher.

