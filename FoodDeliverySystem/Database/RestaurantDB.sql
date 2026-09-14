/* ============================================================================
   RestaurantDB.sql
   Food Delivery Based Restaurant Management System
   CSC 2210 - Object Oriented Programming 2

   Final Adjusted Version

   Changes:
   - Rafsan Azad = SuperAdmin
   - Habibullah Tuhin = RestaurantAdmin
   - Tuhin owns two restaurants

============================================================================ */


IF DB_ID('RestaurantDB') IS NOT NULL
BEGIN
    ALTER DATABASE RestaurantDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE RestaurantDB;
END
GO


CREATE DATABASE RestaurantDB;
GO


USE RestaurantDB;
GO



/* ============================================================================
   SECTION 1 : TABLE CREATION
============================================================================ */


/* ---------------------------------------------------------------------------
   1. Users
--------------------------------------------------------------------------- */

CREATE TABLE Users
(
    UserId       INT IDENTITY(1,1) NOT NULL,
    Name         VARCHAR(100)      NOT NULL,
    Email        VARCHAR(150)      NOT NULL,
    Password     VARCHAR(100)      NOT NULL,
    Phone        VARCHAR(20)       NULL,
    Address      VARCHAR(255)      NULL,
    Role         VARCHAR(20)       NOT NULL,
    Status       VARCHAR(20)       NOT NULL,
    CreatedDate  DATETIME          NOT NULL DEFAULT GETDATE(),

    CONSTRAINT PK_Users PRIMARY KEY (UserId),
    CONSTRAINT UQ_Users_Email UNIQUE (Email),
    CONSTRAINT CK_Users_Role CHECK 
    (Role IN ('SuperAdmin','RestaurantAdmin','Employee','Customer')),
    CONSTRAINT CK_Users_Status CHECK 
    (Status IN ('Active','Inactive','Pending'))
);
GO



/* ---------------------------------------------------------------------------
   2. Restaurants
--------------------------------------------------------------------------- */

CREATE TABLE Restaurants
(
    RestaurantId    INT IDENTITY(1,1) NOT NULL,
    OwnerId         INT NOT NULL,
    RestaurantName  VARCHAR(150) NOT NULL,
    Address         VARCHAR(255) NULL,
    Phone           VARCHAR(20) NULL,
    Status          VARCHAR(20) NOT NULL,

    CONSTRAINT PK_Restaurants PRIMARY KEY (RestaurantId),

    CONSTRAINT FK_Restaurants_Users 
    FOREIGN KEY (OwnerId) REFERENCES Users(UserId),

    CONSTRAINT CK_Restaurants_Status CHECK
    (Status IN ('Active','Inactive','Pending'))
);
GO



/* ---------------------------------------------------------------------------
   3. Employees
--------------------------------------------------------------------------- */

CREATE TABLE Employees
(
    EmployeeId    INT IDENTITY(1,1) NOT NULL,
    UserId        INT NOT NULL,
    RestaurantId  INT NOT NULL,
    Position      VARCHAR(50) NULL,
    JoiningDate   DATE NOT NULL,
    Status        VARCHAR(20) NOT NULL,

    CONSTRAINT PK_Employees PRIMARY KEY (EmployeeId),

    CONSTRAINT FK_Employees_Users 
    FOREIGN KEY (UserId) REFERENCES Users(UserId),

    CONSTRAINT FK_Employees_Restaurants 
    FOREIGN KEY (RestaurantId) REFERENCES Restaurants(RestaurantId),

    CONSTRAINT UQ_Employees_User UNIQUE(UserId),

    CONSTRAINT CK_Employees_Status CHECK
    (Status IN ('Active','Inactive'))
);
GO



/* ---------------------------------------------------------------------------
   4. Categories
--------------------------------------------------------------------------- */

CREATE TABLE Categories
(
    CategoryId    INT IDENTITY(1,1) NOT NULL,
    CategoryName  VARCHAR(100) NOT NULL,
    Status        VARCHAR(20) NOT NULL,

    CONSTRAINT PK_Categories PRIMARY KEY(CategoryId),

    CONSTRAINT UQ_Categories_Name UNIQUE(CategoryName),

    CONSTRAINT CK_Categories_Status CHECK
    (Status IN ('Active','Inactive'))
);
GO



/* ---------------------------------------------------------------------------
   5. Foods
--------------------------------------------------------------------------- */

CREATE TABLE Foods
(
    FoodId        INT IDENTITY(1,1) NOT NULL,
    RestaurantId  INT NOT NULL,
    CategoryId    INT NOT NULL,
    FoodName      VARCHAR(150) NOT NULL,
    Description   VARCHAR(500) NULL,
    Price         DECIMAL(10,2) NOT NULL,
    Stock         INT NOT NULL,
    Status        VARCHAR(20) NOT NULL,

    CONSTRAINT PK_Foods PRIMARY KEY(FoodId),

    CONSTRAINT FK_Foods_Restaurants 
    FOREIGN KEY(RestaurantId) REFERENCES Restaurants(RestaurantId),

    CONSTRAINT FK_Foods_Categories
    FOREIGN KEY(CategoryId) REFERENCES Categories(CategoryId),

    CONSTRAINT CK_Foods_Price CHECK(Price >= 0),

    CONSTRAINT CK_Foods_Stock CHECK(Stock >= 0),

    CONSTRAINT CK_Foods_Status CHECK
    (Status IN ('Available','Unavailable'))
);
GO



/* ---------------------------------------------------------------------------
   6. Cart
--------------------------------------------------------------------------- */

CREATE TABLE Cart
(
    CartId      INT IDENTITY(1,1) NOT NULL,
    CustomerId  INT NOT NULL,
    FoodId      INT NOT NULL,
    Quantity    INT NOT NULL,
    AddedDate   DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT PK_Cart PRIMARY KEY(CartId),

    CONSTRAINT FK_Cart_Users
    FOREIGN KEY(CustomerId) REFERENCES Users(UserId),

    CONSTRAINT FK_Cart_Foods
    FOREIGN KEY(FoodId) REFERENCES Foods(FoodId),

    CONSTRAINT UQ_Cart_Cust_Food UNIQUE(CustomerId,FoodId),

    CONSTRAINT CK_Cart_Quantity CHECK(Quantity > 0)
);
GO



/* ---------------------------------------------------------------------------
   7. Orders
--------------------------------------------------------------------------- */

CREATE TABLE Orders
(
    OrderId      INT IDENTITY(1,1) NOT NULL,
    CustomerId   INT NOT NULL,
    OrderDate    DATETIME NOT NULL DEFAULT GETDATE(),
    TotalAmount  DECIMAL(10,2) NOT NULL,
    OrderStatus  VARCHAR(20) NOT NULL,

    CONSTRAINT PK_Orders PRIMARY KEY(OrderId),

    CONSTRAINT FK_Orders_Users
    FOREIGN KEY(CustomerId) REFERENCES Users(UserId),

    CONSTRAINT CK_Orders_Total CHECK(TotalAmount >= 0),

    CONSTRAINT CK_Orders_Status CHECK
    (OrderStatus IN 
    ('Pending','Accepted','Preparing','Completed','Cancelled'))
);
GO



/* ---------------------------------------------------------------------------
   8. OrderDetails
--------------------------------------------------------------------------- */

CREATE TABLE OrderDetails
(
    OrderDetailId INT IDENTITY(1,1) NOT NULL,
    OrderId       INT NOT NULL,
    FoodId        INT NOT NULL,
    Quantity      INT NOT NULL,
    Price         DECIMAL(10,2) NOT NULL,


    CONSTRAINT PK_OrderDetails PRIMARY KEY(OrderDetailId),

    CONSTRAINT FK_OrderDetails_Orders
    FOREIGN KEY(OrderId) REFERENCES Orders(OrderId),

    CONSTRAINT FK_OrderDetails_Foods
    FOREIGN KEY(FoodId) REFERENCES Foods(FoodId),

    CONSTRAINT CK_OrderDetails_Qty CHECK(Quantity > 0),

    CONSTRAINT CK_OrderDetails_Price CHECK(Price >= 0)
);
GO



/* ---------------------------------------------------------------------------
   9. Payments
--------------------------------------------------------------------------- */

CREATE TABLE Payments
(
    PaymentId      INT IDENTITY(1,1) NOT NULL,
    OrderId        INT NOT NULL,
    PaymentMethod  VARCHAR(30) NOT NULL,
    PaymentStatus  VARCHAR(20) NOT NULL,
    PaymentDate    DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT PK_Payments PRIMARY KEY(PaymentId),

    CONSTRAINT FK_Payments_Orders
    FOREIGN KEY(OrderId) REFERENCES Orders(OrderId),

    CONSTRAINT CK_Payments_Method CHECK
    (PaymentMethod IN 
    ('Cash on Delivery','Card','Mobile Banking')),

    CONSTRAINT CK_Payments_Status CHECK
    (PaymentStatus IN ('Pending','Paid','Failed'))
);
GO
/* ============================================================================
   SECTION 2 : INDEXES
============================================================================ */

CREATE INDEX IX_Foods_Category 
ON Foods(CategoryId);

CREATE INDEX IX_Foods_Restaurant 
ON Foods(RestaurantId);

CREATE INDEX IX_Foods_Name 
ON Foods(FoodName);

CREATE INDEX IX_Orders_Customer 
ON Orders(CustomerId);

CREATE INDEX IX_Orders_Status 
ON Orders(OrderStatus);

CREATE INDEX IX_OrderDetails_Ord 
ON OrderDetails(OrderId);

CREATE INDEX IX_Cart_Customer 
ON Cart(CustomerId);

GO



/* ============================================================================
   SECTION 3 : SAMPLE DATA
============================================================================ */


/* ---------------------------------------------------------------------------
   3.1 Users

   Roles:

   Rafsan Azad        -> SuperAdmin
   Habibullah Tuhin   -> RestaurantAdmin
   Sabbir Hasan       -> Employee
   Shah MD. Zunaed    -> Employee
   Customers          -> Customer

--------------------------------------------------------------------------- */

INSERT INTO Users 
(Name, Email, Password, Phone, Address, Role, Status)

VALUES

('Rafsan Azad',
 'rafsan@foodx.com',
 'Super123',
 '01700000002',
 'Mirpur, Dhaka',
 'SuperAdmin',
 'Active'),

('Habibullah Tuhin',
 'tuhin@foodx.com',
 'Admin123',
 '01700000003',
 'Uttara, Dhaka',
 'RestaurantAdmin',
 'Active'),

('Sabbir Hasan',
 'sabbir@foodx.com',
 'Emp12345',
 '01700000004',
 'Mirpur, Dhaka',
 'Employee',
 'Active'),

('Shah MD. Zunaed',
 'zunaed@foodx.com',
 'Emp12345',
 '01700000005',
 'Uttara, Dhaka',
 'Employee',
 'Active'),

('Ayesha Rahman',
 'ayesha@gmail.com',
 'Cust1234',
 '01800000001',
 'Dhanmondi, Dhaka',
 'Customer',
 'Active'),

('Nafis Iqbal',
 'nafis@gmail.com',
 'Cust1234',
 '01800000002',
 'Bashundhara, Dhaka',
 'Customer',
 'Active'),

('Tanvir Ahmed',
 'tanvir@gmail.com',
 'Cust1234',
 '01800000003',
 'Gulshan, Dhaka',
 'Customer',
 'Active');

GO



/* ---------------------------------------------------------------------------
   3.2 Restaurants

   Tuhin owns two restaurants.

--------------------------------------------------------------------------- */

INSERT INTO Restaurants
(OwnerId, RestaurantName, Address, Phone, Status)

VALUES

(2,
 'Tuhin Kitchen',
 'Uttara Sector 7, Dhaka',
 '01722222222',
 'Active'),

(2,
 'Tuhin Snacks Corner',
 'Dhanmondi, Dhaka',
 '01822222222',
 'Active');

GO



/* ---------------------------------------------------------------------------
   3.3 Employees

--------------------------------------------------------------------------- */

INSERT INTO Employees
(UserId, RestaurantId, Position, JoiningDate, Status)

VALUES

(3,
 1,
 'Chef',
 '2025-01-10',
 'Active'),

(4,
 2,
 'Delivery Rider',
 '2025-02-15',
 'Active');

GO



/* ---------------------------------------------------------------------------
   3.4 Categories

--------------------------------------------------------------------------- */

INSERT INTO Categories
(CategoryName, Status)

VALUES

('Burger','Active'),
('Pizza','Active'),
('Biryani','Active'),
('Beverage','Active'),
('Dessert','Active');

GO



/* ---------------------------------------------------------------------------
   3.5 Foods

--------------------------------------------------------------------------- */

INSERT INTO Foods
(RestaurantId, CategoryId, FoodName, Description, Price, Stock, Status)

VALUES

(1,1,
 'Classic Beef Burger',
 'Grilled beef patty with cheese and lettuce',
 250.00,
 40,
 'Available'),

(1,1,
 'Chicken Cheese Burger',
 'Crispy chicken fillet with double cheese',
 220.00,
 35,
 'Available'),

(1,3,
 'Kacchi Biryani',
 'Mutton kacchi with basmati rice',
 380.00,
 25,
 'Available'),

(1,4,
 'Cold Coffee',
 'Iced coffee with cream',
 150.00,
 60,
 'Available'),


(2,2,
 'Chicken Pizza',
 'Medium chicken pizza with mozzarella',
 650.00,
 20,
 'Available'),

(2,2,
 'BBQ Beef Pizza',
 'Large BBQ beef pizza',
 850.00,
 15,
 'Available'),

(2,3,
 'Chicken Biryani',
 'Traditional chicken biryani',
 220.00,
 8,
 'Available'),

(2,5,
 'Chocolate Lava Cake',
 'Warm cake with molten chocolate centre',
 180.00,
 30,
 'Available'),

(2,4,
 'Fresh Lime Soda',
 'Lime soda with mint',
 90.00,
 0,
 'Unavailable');

GO
/* ============================================================================
   3.6 Cart
============================================================================ */

INSERT INTO Cart
(CustomerId, FoodId, Quantity)

VALUES

(5,1,2),
(5,4,1),
(6,5,1);

GO



/* ============================================================================
   3.7 Orders
============================================================================ */

INSERT INTO Orders
(CustomerId, OrderDate, TotalAmount, OrderStatus)

VALUES

(5,
 '2025-08-01 12:30',
 730.00,
 'Completed'),

(6,
 '2025-08-03 19:05',
 650.00,
 'Preparing'),

(7,
 '2025-08-05 20:40',
 400.00,
 'Pending');

GO



/* ============================================================================
   Order Details
============================================================================ */

INSERT INTO OrderDetails
(OrderId, FoodId, Quantity, Price)

VALUES

(1,1,2,250.00),
(1,4,1,150.00),
(1,8,1,180.00),

(2,5,1,650.00),

(3,7,1,220.00),
(3,8,1,180.00);

GO



/* ============================================================================
   Payments
============================================================================ */

INSERT INTO Payments
(OrderId, PaymentMethod, PaymentStatus)

VALUES

(1,'Cash on Delivery','Paid'),
(2,'Card','Paid'),
(3,'Mobile Banking','Pending');

GO



/* ============================================================================
   SECTION 4 : APPLICATION QUERIES
============================================================================ */


/* ---------------------------------------------------------------------------
   4.1 SEARCH FOOD

   Used for customer food search.
--------------------------------------------------------------------------- */

SELECT 
    f.FoodId,
    f.FoodName,
    f.Price,
    f.Stock,
    r.RestaurantName,
    c.CategoryName

FROM Foods f

INNER JOIN Restaurants r
ON f.RestaurantId = r.RestaurantId

INNER JOIN Categories c
ON f.CategoryId = c.CategoryId

WHERE f.FoodName LIKE '%Burger%';

GO



/* ---------------------------------------------------------------------------
   4.2 FILTER FOOD

   Category + Price + Availability filtering
--------------------------------------------------------------------------- */

SELECT 
    f.FoodId,
    f.FoodName,
    f.Price,
    f.Stock,
    r.RestaurantName,
    c.CategoryName

FROM Foods f

INNER JOIN Restaurants r
ON f.RestaurantId = r.RestaurantId

INNER JOIN Categories c
ON f.CategoryId = c.CategoryId

WHERE 
    c.CategoryId = 1
    AND f.Price BETWEEN 0 AND 500
    AND f.Stock > 0
    AND f.Status = 'Available'
    AND r.Status = 'Active';

GO



/* ---------------------------------------------------------------------------
   4.3 JOIN QUERY

   Invoice generation
--------------------------------------------------------------------------- */


SELECT

    od.OrderDetailId,
    f.FoodName,
    r.RestaurantName,
    od.Quantity,
    od.Price,
    (od.Quantity * od.Price) AS Subtotal

FROM OrderDetails od

INNER JOIN Foods f
ON od.FoodId = f.FoodId

INNER JOIN Restaurants r
ON f.RestaurantId = r.RestaurantId

WHERE od.OrderId = 1;

GO



/* ---------------------------------------------------------------------------
   4.4 GROUP BY QUERY

   Super Admin Sales Report
--------------------------------------------------------------------------- */


SELECT

    r.RestaurantId,
    r.RestaurantName,

    COUNT(DISTINCT o.OrderId) AS TotalOrders,

    SUM(od.Quantity * od.Price) AS TotalSales


FROM Restaurants r


INNER JOIN Foods f
ON r.RestaurantId = f.RestaurantId


INNER JOIN OrderDetails od
ON f.FoodId = od.FoodId


INNER JOIN Orders o
ON od.OrderId = o.OrderId


WHERE o.OrderStatus <> 'Cancelled'


GROUP BY

r.RestaurantId,
r.RestaurantName


ORDER BY TotalSales DESC;

GO



/* ---------------------------------------------------------------------------
   4.5 BEST SELLING FOOD
--------------------------------------------------------------------------- */


SELECT

    f.FoodName,

    SUM(od.Quantity) AS UnitsSold,

    SUM(od.Quantity * od.Price) AS Revenue


FROM OrderDetails od


INNER JOIN Foods f

ON od.FoodId = f.FoodId


GROUP BY f.FoodName


HAVING SUM(od.Quantity) >= 1


ORDER BY UnitsSold DESC;

GO



/* ---------------------------------------------------------------------------
   4.6 LOW STOCK REPORT
--------------------------------------------------------------------------- */


SELECT

FoodId,
FoodName,
Stock


FROM Foods


WHERE RestaurantId = 1
AND Stock <= 10;

GO



PRINT 'RestaurantDB created successfully with 9 tables and sample data.';

GO