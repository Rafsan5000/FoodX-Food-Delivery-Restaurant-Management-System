# 🍽️ FOOD X --- Food Delivery Restaurant Management System

**CSC 2210 --- Object Oriented Programming 2**

## Project Overview

FOOD X is a C# Windows Forms based Food Delivery and Restaurant
Management System. The application provides a complete platform for
managing restaurants, foods, employees, customers, orders, payments, and
invoice generation.

The system follows Object-Oriented Programming principles and uses a
layered architecture with View, Controller, Model, and Database
components.

\---

# Team Members

Name                    Role

\---

Rafsan Azad             Super Admin Module \& Core System
MD. Habibullah Tuhin   Restaurant Admin \& Food Management
Sabbir Hasan Tanim      Customer Module
Shah MD. Zunaed         Order \& Payment Module

\---

# Technologies Used

Component              Technology

\---

Programming Language   C#
Framework              .NET Framework
User Interface         Windows Forms
Database               Microsoft SQL Server
Data Access            ADO.NET
IDE                    Visual Studio
Version Control        GitHub

\---

# Main Features

## Authentication

* Role-based login system
* Separate dashboards for:

  * Super Admin
  * Restaurant Admin
  * Employee
  * Customer

## Super Admin Module

* Manage users
* Manage restaurants
* Manage categories
* View system reports

## Restaurant Admin Module

* Manage restaurant profile
* Food CRUD operations
* Category management
* Employee management
* Order management
* Stock monitoring

## Customer Module

* Browse foods
* Search foods
* Filter by category, price and availability
* Add items to cart
* Checkout order
* Generate invoice
* View order history

## Employee Module

* View restaurant orders
* Accept orders
* Update order status
* Manage payment receiving

\---

# Project Architecture

&#x20;   User Interface (Windows Forms)
                |
                v
           Controller
                |
                v
              Model
                |
                v
        SqlDbDataAccess
                |
                v
         SQL Server Database


\---

# Project Structure

&#x20;   FoodDeliverySystem
    │
    ├── Common
    ├── Controller
    ├── Model
    ├── View
    ├── Database
    │   ├── RestaurantDB.sql
    │   └── SqlDbDataAccess.cs
    ├── Docs
    │   ├── Screenshots
    │   ├── Diagrams
    │   └── Project Report
    └── App.config


\---

# OOP Concepts Used

## Encapsulation

Classes contain data and methods with controlled access.

## Abstraction

Database operations are separated from user interface logic.

## Inheritance

Reusable class structures are used where required.

## Polymorphism

Different operations are handled through object-oriented methods.

\---

# Database Information

Database Name:

&#x20;   RestaurantDB


Main Tables:

* Users
* Restaurants
* Employees
* Categories
* Foods
* Cart
* Orders
* OrderDetails
* Payments

SQL File:

&#x20;   Database/RestaurantDB.sql


\---

# Database Relationships

&#x20;   Users
     |
     +---- Restaurants
     |
     +---- Employees
     |
     +---- Orders
            |
            +---- OrderDetails
                        |
                        +---- Foods
                               |
                               +---- Categories

    Orders
     |
     +---- Payments

    Users
     |
     +---- Cart


\---

# Test Credentials

## Super Admin

Email:

&#x20;   rafsan@foodx.com


Password:

&#x20;   Super123


## Restaurant Admin

Email:

&#x20;   tuhin@foodx.com


Password:

&#x20;   Admin123


## Employee

Email:

&#x20;   sabbir@foodx.com


Password:

&#x20;   Emp12345


## Customer

Email:

&#x20;   ayesha@gmail.com


Password:

&#x20;   Cust1234


\---

# How To Run

1. Open Visual Studio.
2. Open:

```{=html}
<!-- -->
```

&#x20;   FoodDeliverySystem.sln


3. Open SQL Server Management Studio.
4. Execute:

```{=html}
<!-- -->
```

&#x20;   Database/RestaurantDB.sql


5. Update connection string in:

```{=html}
<!-- -->
```

&#x20;   App.config


6. Run the application.

\---

# Screenshots

All project screenshots are available in:

&#x20;   Docs/Screenshots


\---

# Diagrams

Project diagrams are available in:

&#x20;   Docs/Diagrams


Includes: - System Architecture Diagram - ER Diagram - Use Case
Diagram - Class Diagram - Workflow Diagram

\---

# Demo Video

Video Link:

&#x20;   https://drive.google.com/file/d/1PeKYKlRUKgvafsT5AZQ7PskZUPFUx5TT/view?usp=drive\_link

# Individual Contribution

This is a group project. Each member contributed to different modules:

* Rafsan Azad: Core system, Super Admin and database coordination
* MD. Habibullah Tuhin: Restaurant Admin and Food Management
* Sabbir Hasan Tanim: Customer Module
* Shah MD. Zunaed: Order and Payment Module

\---

# License

This project is developed for academic purposes as part of the OOP2
Final Project.

