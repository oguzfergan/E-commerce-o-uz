DROP DATABASE IF EXISTS ecommerce_db;
CREATE DATABASE ecommerce_db;
USE ecommerce_db;


CREATE TABLE Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    Username VARCHAR(50) NOT NULL UNIQUE,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    Role ENUM('Customer', 'Seller', 'Administrator') NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    PhoneNumber VARCHAR(20),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    
    CONSTRAINT chk_email_format CHECK (Email LIKE '%@%.%'),
    CONSTRAINT chk_phone_format CHECK (PhoneNumber IS NULL OR PhoneNumber REGEXP '^[0-9+\\-\\s()]+$')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE INDEX idx_users_role ON Users(Role);
CREATE INDEX idx_users_email ON Users(Email);


CREATE TABLE Addresses (
    AddressID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    AddressType ENUM('Shipping', 'Billing', 'Both') NOT NULL,
    Street VARCHAR(200) NOT NULL,
    City VARCHAR(100) NOT NULL,
    State VARCHAR(100) NOT NULL,
    ZipCode VARCHAR(20) NOT NULL,
    Country VARCHAR(100) NOT NULL DEFAULT 'Turkey',
    IsDefault BOOLEAN DEFAULT FALSE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    
    CONSTRAINT fk_addresses_user FOREIGN KEY (UserID) 
        REFERENCES Users(UserID) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    
    
    CONSTRAINT chk_zipcode CHECK (ZipCode REGEXP '^[0-9A-Za-z\\s\\-]+$')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE INDEX idx_addresses_user ON Addresses(UserID);
CREATE INDEX idx_addresses_type ON Addresses(AddressType);


CREATE TABLE Categories (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL UNIQUE,
    Description TEXT,
    ParentCategoryID INT DEFAULT NULL,
    CreatedBy INT NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    
    CONSTRAINT fk_categories_creator FOREIGN KEY (CreatedBy) 
        REFERENCES Users(UserID) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    
    CONSTRAINT fk_categories_parent FOREIGN KEY (ParentCategoryID) 
        REFERENCES Categories(CategoryID) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE,
    
   
    CONSTRAINT chk_category_creator_role CHECK (
        CreatedBy IN (SELECT UserID FROM Users WHERE Role = 'Administrator')
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE INDEX idx_categories_name ON Categories(CategoryName);
CREATE INDEX idx_categories_parent ON Categories(ParentCategoryID);


CREATE TABLE Catalogs (
    CatalogID INT AUTO_INCREMENT PRIMARY KEY,
    SellerID INT NOT NULL UNIQUE,
    CatalogName VARCHAR(200) NOT NULL,
    Description TEXT,
    IsActive BOOLEAN DEFAULT TRUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    
    CONSTRAINT fk_catalogs_seller FOREIGN KEY (SellerID) 
        REFERENCES Users(UserID) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    
    
    CONSTRAINT chk_catalog_seller_role CHECK (
        SellerID IN (SELECT UserID FROM Users WHERE Role = 'Seller')
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE INDEX idx_catalogs_seller ON Catalogs(SellerID);
CREATE INDEX idx_catalogs_active ON Catalogs(IsActive);


CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryID INT NOT NULL,
    CatalogID INT NOT NULL,
    ProductName VARCHAR(200) NOT NULL,
    Description TEXT,
    Price DECIMAL(10, 2) NOT NULL,
    StockQuantity INT NOT NULL DEFAULT 0,
    SKU VARCHAR(100) UNIQUE,
    IsActive BOOLEAN DEFAULT TRUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    
    CONSTRAINT fk_products_category FOREIGN KEY (CategoryID) 
        REFERENCES Categories(CategoryID) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    
    CONSTRAINT fk_products_catalog FOREIGN KEY (CatalogID) 
        REFERENCES Catalogs(CatalogID) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    
    
    CONSTRAINT chk_products_price CHECK (Price >= 0),
    CONSTRAINT chk_products_stock CHECK (StockQuantity >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE INDEX idx_products_category ON Products(CategoryID);
CREATE INDEX idx_products_catalog ON Products(CatalogID);
CREATE INDEX idx_products_name ON Products(ProductName);
CREATE INDEX idx_products_price ON Products(Price);
CREATE INDEX idx_products_active ON Products(IsActive);
CREATE FULLTEXT INDEX idx_products_search ON Products(ProductName, Description);


CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    SellerID INT NOT NULL,
    ShippingAddressID INT NOT NULL,
    BillingAddressID INT NOT NULL,
    OrderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    TotalAmount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    OrderStatus ENUM('Pending', 'Confirmed', 'Processing', 'Shipped', 'Delivered', 'Cancelled') NOT NULL DEFAULT 'Pending',
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    
    CONSTRAINT fk_orders_customer FOREIGN KEY (CustomerID) 
        REFERENCES Users(UserID) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    
    CONSTRAINT fk_orders_seller FOREIGN KEY (SellerID) 
        REFERENCES Users(UserID) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    
    CONSTRAINT fk_orders_shipping_address FOREIGN KEY (ShippingAddressID) 
        REFERENCES Addresses(AddressID) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    
    CONSTRAINT fk_orders_billing_address FOREIGN KEY (BillingAddressID) 
        REFERENCES Addresses(AddressID) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    
    
    CONSTRAINT chk_orders_total CHECK (TotalAmount >= 0),
    CONSTRAINT chk_orders_customer_role CHECK (
        CustomerID IN (SELECT UserID FROM Users WHERE Role = 'Customer')
    ),
    CONSTRAINT chk_orders_seller_role CHECK (
        SellerID IN (SELECT UserID FROM Users WHERE Role = 'Seller')
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE INDEX idx_orders_customer ON Orders(CustomerID);
CREATE INDEX idx_orders_seller ON Orders(SellerID);
CREATE INDEX idx_orders_status ON Orders(OrderStatus);
CREATE INDEX idx_orders_date ON Orders(OrderDate);


CREATE TABLE OrderItems (
    OrderItemID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL,
    Subtotal DECIMAL(10, 2) NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    
    CONSTRAINT fk_orderitems_order FOREIGN KEY (OrderID) 
        REFERENCES Orders(OrderID) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    
    CONSTRAINT fk_orderitems_product FOREIGN KEY (ProductID) 
        REFERENCES Products(ProductID) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    
    
    CONSTRAINT chk_orderitems_quantity CHECK (Quantity > 0),
    CONSTRAINT chk_orderitems_price CHECK (UnitPrice >= 0),
    CONSTRAINT chk_orderitems_subtotal CHECK (Subtotal >= 0),
    
    
    CONSTRAINT uq_orderitems_order_product UNIQUE (OrderID, ProductID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE INDEX idx_orderitems_order ON OrderItems(OrderID);
CREATE INDEX idx_orderitems_product ON OrderItems(ProductID);


CREATE TABLE Payments (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    PaymentMethod ENUM('Credit Card', 'Debit Card', 'Bank Transfer', 'Wallet', 'Cash on Delivery') NOT NULL,
    PaymentAmount DECIMAL(10, 2) NOT NULL,
    PaymentStatus ENUM('Pending', 'Completed', 'Failed', 'Refunded') NOT NULL DEFAULT 'Pending',
    PaymentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    TransactionID VARCHAR(100) UNIQUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    
    CONSTRAINT fk_payments_order FOREIGN KEY (OrderID) 
        REFERENCES Orders(OrderID) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    
    
    CONSTRAINT chk_payments_amount CHECK (PaymentAmount > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE INDEX idx_payments_order ON Payments(OrderID);
CREATE INDEX idx_payments_status ON Payments(PaymentStatus);
CREATE INDEX idx_payments_transaction ON Payments(TransactionID);


CREATE TABLE Shipments (
    ShipmentID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL UNIQUE,
    TrackingNumber VARCHAR(100) UNIQUE,
    ShipmentStatus ENUM('Preparing', 'Shipped', 'In Transit', 'Out for Delivery', 'Delivered', 'Returned') NOT NULL DEFAULT 'Preparing',
    ShippedDate TIMESTAMP NULL,
    EstimatedDelivery DATE NULL,
    ActualDelivery TIMESTAMP NULL,
    Carrier VARCHAR(100),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    
    CONSTRAINT fk_shipments_order FOREIGN KEY (OrderID) 
        REFERENCES Orders(OrderID) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    
    
    CONSTRAINT chk_shipments_dates CHECK (
        ShippedDate IS NULL OR 
        EstimatedDelivery IS NULL OR 
        ShippedDate <= EstimatedDelivery
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE INDEX idx_shipments_order ON Shipments(OrderID);
CREATE INDEX idx_shipments_status ON Shipments(ShipmentStatus);
CREATE INDEX idx_shipments_tracking ON Shipments(TrackingNumber);


CREATE TABLE Reviews (
    ReviewID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    ProductID INT NOT NULL,
    OrderItemID INT NOT NULL UNIQUE,
    Rating INT NOT NULL,
    ReviewText TEXT,
    ReviewDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    
    CONSTRAINT fk_reviews_customer FOREIGN KEY (CustomerID) 
        REFERENCES Users(UserID) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    
    CONSTRAINT fk_reviews_product FOREIGN KEY (ProductID) 
        REFERENCES Products(ProductID) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    
    CONSTRAINT fk_reviews_orderitem FOREIGN KEY (OrderItemID) 
        REFERENCES OrderItems(OrderItemID) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    
    
    CONSTRAINT chk_reviews_rating CHECK (Rating >= 1 AND Rating <= 5),
    CONSTRAINT chk_reviews_customer_role CHECK (
        CustomerID IN (SELECT UserID FROM Users WHERE Role = 'Customer')
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE INDEX idx_reviews_customer ON Reviews(CustomerID);
CREATE INDEX idx_reviews_product ON Reviews(ProductID);
CREATE INDEX idx_reviews_rating ON Reviews(Rating);
CREATE INDEX idx_reviews_date ON Reviews(ReviewDate);


CREATE VIEW vw_CustomerOrderHistory AS
SELECT 
    o.OrderID,
    o.OrderDate,
    CONCAT(u.FirstName, ' ', u.LastName) AS CustomerName,
    u.Email AS CustomerEmail,
    o.TotalAmount,
    o.OrderStatus,
    p.PaymentStatus,
    s.ShipmentStatus
FROM Orders o
JOIN Users u ON o.CustomerID = u.UserID
LEFT JOIN Payments p ON o.OrderID = p.OrderID
LEFT JOIN Shipments s ON o.OrderID = s.OrderID
WHERE u.Role = 'Customer';


CREATE VIEW vw_SellerProductCatalog AS
SELECT 
    p.ProductID,
    p.ProductName,
    p.Description,
    p.Price,
    p.StockQuantity,
    cat.CategoryName,
    CONCAT(u.FirstName, ' ', u.LastName) AS SellerName,
    u.Email AS SellerEmail,
    p.IsActive
FROM Products p
JOIN Catalogs c ON p.CatalogID = c.CatalogID
JOIN Users u ON c.SellerID = u.UserID
JOIN Categories cat ON p.CategoryID = cat.CategoryID
WHERE u.Role = 'Seller';


CREATE VIEW vw_ProductReviewsSummary AS
SELECT 
    p.ProductID,
    p.ProductName,
    COUNT(r.ReviewID) AS TotalReviews,
    AVG(r.Rating) AS AverageRating,
    MIN(r.Rating) AS MinRating,
    MAX(r.Rating) AS MaxRating
FROM Products p
LEFT JOIN Reviews r ON p.ProductID = r.ProductID
GROUP BY p.ProductID, p.ProductName;


CREATE VIEW vw_LowStockProducts AS
SELECT 
    p.ProductID,
    p.ProductName,
    p.StockQuantity,
    CONCAT(u.FirstName, ' ', u.LastName) AS SellerName,
    u.Email AS SellerEmail
FROM Products p
JOIN Catalogs c ON p.CatalogID = c.CatalogID
JOIN Users u ON c.SellerID = u.UserID
WHERE p.StockQuantity < 10 AND p.IsActive = TRUE;


CREATE VIEW vw_PendingOrders AS
SELECT 
    o.OrderID,
    o.OrderDate,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    CONCAT(s.FirstName, ' ', s.LastName) AS SellerName,
    o.TotalAmount,
    o.OrderStatus,
    p.PaymentStatus
FROM Orders o
JOIN Users c ON o.CustomerID = c.UserID
JOIN Users s ON o.SellerID = s.UserID
LEFT JOIN Payments p ON o.OrderID = p.OrderID
WHERE o.OrderStatus IN ('Pending', 'Confirmed', 'Processing');


DELIMITER $$
CREATE TRIGGER trg_update_order_total_after_insert
AFTER INSERT ON OrderItems
FOR EACH ROW
BEGIN
    UPDATE Orders 
    SET TotalAmount = (
        SELECT COALESCE(SUM(Subtotal), 0) 
        FROM OrderItems 
        WHERE OrderID = NEW.OrderID
    )
    WHERE OrderID = NEW.OrderID;
END$$

CREATE TRIGGER trg_update_order_total_after_update
AFTER UPDATE ON OrderItems
FOR EACH ROW
BEGIN
    UPDATE Orders 
    SET TotalAmount = (
        SELECT COALESCE(SUM(Subtotal), 0) 
        FROM OrderItems 
        WHERE OrderID = NEW.OrderID
    )
    WHERE OrderID = NEW.OrderID;
END$$

CREATE TRIGGER trg_update_order_total_after_delete
AFTER DELETE ON OrderItems
FOR EACH ROW
BEGIN
    UPDATE Orders 
    SET TotalAmount = (
        SELECT COALESCE(SUM(Subtotal), 0) 
        FROM OrderItems 
        WHERE OrderID = OLD.OrderID
    )
    WHERE OrderID = OLD.OrderID;
END$$


CREATE TRIGGER trg_decrease_stock_on_order
AFTER INSERT ON OrderItems
FOR EACH ROW
BEGIN
    UPDATE Products 
    SET StockQuantity = StockQuantity - NEW.Quantity
    WHERE ProductID = NEW.ProductID;
END$$


CREATE TRIGGER trg_check_stock_before_order
BEFORE INSERT ON OrderItems
FOR EACH ROW
BEGIN
    DECLARE available_stock INT;
    
    SELECT StockQuantity INTO available_stock
    FROM Products
    WHERE ProductID = NEW.ProductID;
    
    IF available_stock < NEW.Quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient stock available for this product';
    END IF;
END$$


CREATE TRIGGER trg_calculate_subtotal_before_insert
BEFORE INSERT ON OrderItems
FOR EACH ROW
BEGIN
    SET NEW.Subtotal = NEW.Quantity * NEW.UnitPrice;
END$$

CREATE TRIGGER trg_calculate_subtotal_before_update
BEFORE UPDATE ON OrderItems
FOR EACH ROW
BEGIN
    SET NEW.Subtotal = NEW.Quantity * NEW.UnitPrice;
END$$

DELIMITER ;


DELIMITER $$
CREATE PROCEDURE sp_PlaceOrder(
    IN p_CustomerID INT,
    IN p_SellerID INT,
    IN p_ShippingAddressID INT,
    IN p_BillingAddressID INT,
    OUT p_OrderID INT
)
BEGIN
    
    INSERT INTO Orders (CustomerID, SellerID, ShippingAddressID, BillingAddressID, OrderStatus)
    VALUES (p_CustomerID, p_SellerID, p_ShippingAddressID, p_BillingAddressID, 'Pending');
    
    
    SET p_OrderID = LAST_INSERT_ID();
END$$


CREATE PROCEDURE sp_AddOrderItem(
    IN p_OrderID INT,
    IN p_ProductID INT,
    IN p_Quantity INT
)
BEGIN
    DECLARE v_UnitPrice DECIMAL(10,2);
    
    
    SELECT Price INTO v_UnitPrice
    FROM Products
    WHERE ProductID = p_ProductID;
    
    
    INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice)
    VALUES (p_OrderID, p_ProductID, p_Quantity, v_UnitPrice);
END$$


CREATE PROCEDURE sp_ProcessPayment(
    IN p_OrderID INT,
    IN p_PaymentMethod VARCHAR(50),
    IN p_PaymentAmount DECIMAL(10,2),
    IN p_TransactionID VARCHAR(100)
)
BEGIN
    INSERT INTO Payments (OrderID, PaymentMethod, PaymentAmount, PaymentStatus, TransactionID)
    VALUES (p_OrderID, p_PaymentMethod, p_PaymentAmount, 'Completed', p_TransactionID);
    
    
    UPDATE Orders SET OrderStatus = 'Confirmed' WHERE OrderID = p_OrderID;
END$$


CREATE PROCEDURE sp_CreateShipment(
    IN p_OrderID INT,
    IN p_TrackingNumber VARCHAR(100),
    IN p_Carrier VARCHAR(100)
)
BEGIN
    INSERT INTO Shipments (OrderID, TrackingNumber, Carrier, ShipmentStatus)
    VALUES (p_OrderID, p_TrackingNumber, p_Carrier, 'Preparing');
    
 
    UPDATE Orders SET OrderStatus = 'Processing' WHERE OrderID = p_OrderID;
END$$


CREATE PROCEDURE sp_UpdateShipmentStatus(
    IN p_ShipmentID INT,
    IN p_NewStatus VARCHAR(50)
)
BEGIN
    UPDATE Shipments 
    SET ShipmentStatus = p_NewStatus,
        ShippedDate = CASE WHEN p_NewStatus = 'Shipped' THEN NOW() ELSE ShippedDate END,
        ActualDelivery = CASE WHEN p_NewStatus = 'Delivered' THEN NOW() ELSE ActualDelivery END
    WHERE ShipmentID = p_ShipmentID;
    
    IF p_NewStatus = 'Shipped' THEN
        UPDATE Orders SET OrderStatus = 'Shipped' 
        WHERE OrderID = (SELECT OrderID FROM Shipments WHERE ShipmentID = p_ShipmentID);
    ELSEIF p_NewStatus = 'Delivered' THEN
        UPDATE Orders SET OrderStatus = 'Delivered' 
        WHERE OrderID = (SELECT OrderID FROM Shipments WHERE ShipmentID = p_ShipmentID);
    END IF;
END$$

DELIMITER ;


ALTER TABLE Users COMMENT = 'Stores all system users with role-based access';
ALTER TABLE Addresses COMMENT = 'User addresses for shipping and billing';
ALTER TABLE Categories COMMENT = 'Product categories managed by administrators';
ALTER TABLE Catalogs COMMENT = 'Seller catalogs (1:1 with sellers)';
ALTER TABLE Products COMMENT = 'Products offered in seller catalogs';
ALTER TABLE Orders COMMENT = 'Customer orders (single seller per order)';
ALTER TABLE OrderItems COMMENT = 'Line items for orders';
ALTER TABLE Payments COMMENT = 'Payment transactions for orders';
ALTER TABLE Shipments COMMENT = 'Shipment tracking (1:1 with orders)';
ALTER TABLE Reviews COMMENT = 'Customer reviews for purchased products';


SELECT 'Database schema created successfully!' AS Message;
SELECT 'Total Tables Created: 10' AS Info;
SELECT 'Total Views Created: 5' AS Info;
SELECT 'Total Triggers Created: 6' AS Info;
SELECT 'Total Stored Procedures Created: 5' AS Info;


CREATE TABLE IF NOT EXISTS Coupons (
    CouponID INT AUTO_INCREMENT PRIMARY KEY,
    Code VARCHAR(50) NOT NULL UNIQUE,
    DiscountPercent INT NOT NULL, 
    ExpiryDate DATE NOT NULL,
    IsActive BOOLEAN DEFAULT TRUE,
    CONSTRAINT chk_discount CHECK (DiscountPercent > 0 AND DiscountPercent <= 100)
);

ALTER TABLE Orders ADD COLUMN DiscountAmount DECIMAL(10, 2) DEFAULT 0.00;


DELIMITER $$

DROP PROCEDURE IF EXISTS sp_ApplyCoupon$$

CREATE PROCEDURE sp_ApplyCoupon(
    IN p_OrderID INT,
    IN p_CouponCode VARCHAR(50),
    OUT p_Success BOOLEAN,
    OUT p_Message VARCHAR(100),
    OUT p_NewTotal DECIMAL(10, 2)
)
BEGIN
    DECLARE v_DiscountPercent INT;
    DECLARE v_CurrentTotal DECIMAL(10, 2);
    DECLARE v_DiscountAmount DECIMAL(10, 2);
    DECLARE v_Expiry DATE;
    DECLARE v_IsActive BOOLEAN;
    
    SET p_Success = FALSE;
    SET p_NewTotal = 0;

    SELECT DiscountPercent, ExpiryDate, IsActive 
    INTO v_DiscountPercent, v_Expiry, v_IsActive
    FROM Coupons 
    WHERE Code = p_CouponCode;
    
    IF v_DiscountPercent IS NULL THEN
        SET p_Message = 'Invalid Coupon Code!';
    ELSEIF v_IsActive = FALSE THEN
        SET p_Message = 'This coupon is no longer active.';
    ELSEIF v_Expiry < CURDATE() THEN
        SET p_Message = 'This coupon has expired.';
    ELSE
        SELECT COALESCE(SUM(Subtotal), 0) INTO v_CurrentTotal
        FROM OrderItems WHERE OrderID = p_OrderID;
        
        IF v_CurrentTotal = 0 THEN
            SET p_Message = 'Your cart is empty, discount cannot be applied.';
        ELSE
            SET v_DiscountAmount = (v_CurrentTotal * v_DiscountPercent) / 100;
            
            UPDATE Orders 
            SET DiscountAmount = v_DiscountAmount,
                TotalAmount = v_CurrentTotal - v_DiscountAmount
            WHERE OrderID = p_OrderID;
            
            SET p_Success = TRUE;
            SET p_Message = CONCAT(v_DiscountPercent, '% Discount Applied Successfully!');
            SET p_NewTotal = v_CurrentTotal - v_DiscountAmount;
        END IF;
    END IF;
END$$

DELIMITER ;

