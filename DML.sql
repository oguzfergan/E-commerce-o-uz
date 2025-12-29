USE ecommerce_db;

-- Insert Administrator user
INSERT INTO Users (name, email, password, role, is_active) VALUES
('Admin User', 'admin@ecommerce.com', 'admin123', 'Administrator', TRUE);

-- Insert sample customers
INSERT INTO Users (name, email, password, role) VALUES
('John Doe', 'john@email.com', 'pass123', 'Customer'),
('Jane Smith', 'jane@email.com', 'pass123', 'Customer'),
('Alice Johnson', 'alice.johnson@email.com', 'pass123', 'Customer'),
('Bob Wilson', 'bob.wilson@email.com', 'pass123', 'Customer');

-- Insert sample sellers
INSERT INTO Users (name, email, password, role) VALUES
('TechStore', 'techstore@email.com', 'pass123', 'Seller'),
('BookShop', 'bookshop@email.com', 'pass123', 'Seller'),
('FashionHub', 'fashionhub@email.com', 'pass123', 'Seller');

-- Insert addresses for customers
INSERT INTO Addresses (user_id, street, city, country, address_type, is_default) VALUES
(2, '123 Main St', 'New York', 'USA', 'Both', TRUE),
(2, '456 Second Ave', 'New York', 'USA', 'Shipping', FALSE),
(3, '789 Third St', 'Los Angeles', 'USA', 'Both', TRUE),
(4, '321 Oak Avenue', 'Chicago', 'USA', 'Both', TRUE),
(5, '654 Pine Street', 'Boston', 'USA', 'Both', TRUE);

-- Insert addresses for sellers
INSERT INTO Addresses (user_id, street, city, country) VALUES
(6, '100 Tech Boulevard', 'San Francisco', 'USA'),
(7, '200 Book Lane', 'Seattle', 'USA'),
(8, '300 Fashion Avenue', 'New York', 'USA');

-- Insert categories
INSERT INTO Categories (name, parent_category_id, description, created_by) VALUES
('Electronics', NULL, 'Electronic devices and accessories', 1),
('Books', NULL, 'Books and publications', 1),
('Clothing', NULL, 'Fashion and apparel', 1),
('Computers', 1, 'Portable computers', 1),
('Smartphones', 1, 'Mobile phones and accessories', 1),
('Fiction', 2, 'Fiction books', 1),
('Non-Fiction', 2, 'Non-fiction books', 1),
('Men\'s Clothing', 3, 'Clothing for men', 1),
('Women\'s Clothing', 3, 'Clothing for women', 1);

-- Create catalogs for sellers
INSERT INTO Catalogs (seller_id, catalog_name, description, is_available) VALUES
(6, 'TechStore Premium Catalog', 'Latest electronics and gadgets', TRUE),
(7, 'BookShop Library', 'Wide selection of books', TRUE),
(8, 'FashionHub Collection', 'Trendy fashion and accessories', TRUE);

-- Insert products for TechStore
INSERT INTO Products (catalog_id, category_id, name, description, price, stock_quantity, image_url) VALUES
(1, 4, 'Laptop Dell XPS 13', 'High-performance laptop with Intel i7, 16GB RAM, 512GB SSD', 1299.99, 15, NULL),
(1, 4, 'MacBook Air M2', 'Apple MacBook Air with M2 chip, 8GB RAM, 256GB SSD', 999.99, 10, NULL),
(1, 5, 'iPhone 15 Pro', 'Latest iPhone with A17 Pro chip, 128GB storage', 1099.99, 25, NULL),
(1, 5, 'Samsung Galaxy S24', 'Android flagship phone with 256GB storage', 899.99, 30, NULL),
(1, 1, 'Wireless Mouse', 'Ergonomic wireless mouse with USB receiver', 29.99, 100, NULL);

-- Insert products for BookShop
INSERT INTO Products (catalog_id, category_id, name, description, price, stock_quantity, image_url) VALUES
(2, 6, 'The Great Gatsby', 'Classic novel by F. Scott Fitzgerald', 14.99, 50, NULL),
(2, 6, '1984 by George Orwell', 'Dystopian fiction masterpiece', 15.99, 60, NULL),
(2, 7, 'Sapiens', 'A Brief History of Humankind by Yuval Noah Harari', 24.99, 45, NULL),
(2, 7, 'Atomic Habits', 'Tiny Changes, Remarkable Results by James Clear', 19.99, 70, NULL);

-- Insert products for FashionHub
INSERT INTO Products (catalog_id, category_id, name, description, price, stock_quantity, image_url) VALUES
(3, 8, 'Men\'s Cotton T-Shirt', 'Comfortable cotton t-shirt, various colors', 29.99, 200, NULL),
(3, 8, 'Men\'s Denim Jeans', 'Classic fit denim jeans', 89.99, 150, NULL),
(3, 9, 'Women\'s Summer Dress', 'Elegant floral summer dress', 129.99, 80, NULL),
(3, 9, 'Women\'s Blouse', 'Professional work blouse', 69.99, 120, NULL);

-- Insert a completed order with items (for testing reviews)
INSERT INTO Orders (customer_id, seller_id, shipping_address_id, billing_address_id, order_date, total_amount, status) VALUES
(2, 6, 1, 1, '2025-10-15 10:30:00', 1329.98, 'Shipped');

INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase, subtotal) VALUES
(1, 1, 1, 1299.99, 1299.99),
(1, 5, 1, 29.99, 29.99);

INSERT INTO Payments (order_id, transaction_id, amount, method, status) VALUES
(1, 'TXN123456', 1329.98, 'Credit Card', 'Completed');

INSERT INTO Shipments (order_id, tracking_number, shipped_date, status, carrier) VALUES
(1, 'TRACK123456', '2025-10-16', 'In Transit', 'FedEx');

-- Insert sample reviews
INSERT INTO Reviews (customer_id, product_id, order_id, order_item_id, rating, comment) VALUES
(2, 1, 1, 1, 5, 'Excellent laptop! Very fast and reliable.');

-- Insert sample coupons
INSERT INTO Coupons (code, discount_percent, expiry_date, min_order_amount, is_active) VALUES
('WELCOME10', 10, '2026-12-31', 50.00, TRUE),
('SPRING20', 20, '2026-05-01', 100.00, TRUE),
('SUMMER15', 15, '2026-08-31', 75.00, TRUE);

SELECT 'Sample data inserted successfully!' AS Message;
SELECT COUNT(*) AS TotalUsers FROM Users;
SELECT COUNT(*) AS TotalProducts FROM Products;
SELECT COUNT(*) AS TotalOrders FROM Orders;
