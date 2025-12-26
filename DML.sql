USE ecommerce_db;


SET FOREIGN_KEY_CHECKS = 0;


INSERT INTO Users (Username, Email, PasswordHash, Role, FirstName, LastName, PhoneNumber) VALUES
('admin_john', 'john.admin@ecommerce.com', '$2y$10$abcdefghijklmnopqrstuvwxyz123456', 'Administrator', 'John', 'Anderson', '+90-555-0001'),
('admin_sarah', 'sarah.admin@ecommerce.com', '$2y$10$abcdefghijklmnopqrstuvwxyz123457', 'Administrator', 'Sarah', 'Williams', '+90-555-0002');


INSERT INTO Users (Username, Email, PasswordHash, Role, FirstName, LastName, PhoneNumber) VALUES
('seller_techstore', 'contact@techstore.com', '$2y$10$abcdefghijklmnopqrstuvwxyz123458', 'Seller', 'Michael', 'Tech', '+90-555-1001'),
('seller_fashionhub', 'info@fashionhub.com', '$2y$10$abcdefghijklmnopqrstuvwxyz123459', 'Seller', 'Emma', 'Fashion', '+90-555-1002'),
('seller_bookworld', 'sales@bookworld.com', '$2y$10$abcdefghijklmnopqrstuvwxyz123460', 'Seller', 'David', 'Reader', '+90-555-1003'),
('seller_homegarden', 'hello@homegarden.com', '$2y$10$abcdefghijklmnopqrstuvwxyz123461', 'Seller', 'Lisa', 'Green', '+90-555-1004'),
('seller_sportsgear', 'support@sportsgear.com', '$2y$10$abcdefghijklmnopqrstuvwxyz123462', 'Seller', 'James', 'Athletic', '+90-555-1005');


INSERT INTO Users (Username, Email, PasswordHash, Role, FirstName, LastName, PhoneNumber) VALUES
('customer_alice', 'alice.johnson@email.com', '$2y$10$abcdefghijklmnopqrstuvwxyz123463', 'Customer', 'Alice', 'Johnson', '+90-555-2001'),
('customer_bob', 'bob.smith@email.com', '$2y$10$abcdefghijklmnopqrstuvwxyz123464', 'Customer', 'Bob', 'Smith', '+90-555-2002'),
('customer_carol', 'carol.white@email.com', '$2y$10$abcdefghijklmnopqrstuvwxyz123465', 'Customer', 'Carol', 'White', '+90-555-2003'),
('customer_daniel', 'daniel.brown@email.com', '$2y$10$abcdefghijklmnopqrstuvwxyz123466', 'Customer', 'Daniel', 'Brown', '+90-555-2004'),
('customer_emily', 'emily.davis@email.com', '$2y$10$abcdefghijklmnopqrstuvwxyz123467', 'Customer', 'Emily', 'Davis', '+90-555-2005'),
('customer_frank', 'frank.miller@email.com', '$2y$10$abcdefghijklmnopqrstuvwxyz123468', 'Customer', 'Frank', 'Miller', '+90-555-2006'),
('customer_grace', 'grace.wilson@email.com', '$2y$10$abcdefghijklmnopqrstuvwxyz123469', 'Customer', 'Grace', 'Wilson', '+90-555-2007'),
('customer_henry', 'henry.moore@email.com', '$2y$10$abcdefghijklmnopqrstuvwxyz123470', 'Customer', 'Henry', 'Moore', '+90-555-2008');


INSERT INTO Addresses (UserID, AddressType, Street, City, State, ZipCode, Country, IsDefault) VALUES

(8, 'Both', 'Atatürk Caddesi No: 123', 'Istanbul', 'Istanbul', '34000', 'Turkey', TRUE),
(8, 'Shipping', 'İstiklal Sokak No: 45', 'Istanbul', 'Istanbul', '34100', 'Turkey', FALSE),


(9, 'Both', 'Cumhuriyet Bulvarı No: 78', 'Ankara', 'Ankara', '06000', 'Turkey', TRUE),


(10, 'Shipping', 'Kıbrıs Şehitleri Caddesi No: 234', 'Izmir', 'Izmir', '35000', 'Turkey', TRUE),
(10, 'Billing', 'Gazi Mustafa Kemal Bulvarı No: 567', 'Izmir', 'Izmir', '35100', 'Turkey', FALSE),


(11, 'Both', 'Atatürk Bulvarı No: 89', 'Bursa', 'Bursa', '16000', 'Turkey', TRUE),


(12, 'Both', 'Fevzi Çakmak Caddesi No: 156', 'Antalya', 'Antalya', '07000', 'Turkey', TRUE),


(13, 'Shipping', 'Konak Meydanı No: 34', 'Izmir', 'Izmir', '35200', 'Turkey', TRUE),


(14, 'Both', 'Taksim Meydanı No: 12', 'Istanbul', 'Istanbul', '34250', 'Turkey', TRUE),


(15, 'Both', 'Kızılay Meydanı No: 90', 'Ankara', 'Ankara', '06420', 'Turkey', TRUE);


INSERT INTO Addresses (UserID, AddressType, Street, City, State, ZipCode, Country, IsDefault) VALUES
(3, 'Both', 'Teknoloji Caddesi No: 1', 'Istanbul', 'Istanbul', '34200', 'Turkey', TRUE),
(4, 'Both', 'Moda Sokağı No: 25', 'Istanbul', 'Istanbul', '34300', 'Turkey', TRUE),
(5, 'Both', 'Kitap Pazarı Caddesi No: 67', 'Ankara', 'Ankara', '06100', 'Turkey', TRUE),
(6, 'Both', 'Bahçe Yolu No: 44', 'Izmir', 'Izmir', '35300', 'Turkey', TRUE),
(7, 'Both', 'Spor Kompleksi No: 88', 'Bursa', 'Bursa', '16100', 'Turkey', TRUE);


INSERT INTO Categories (CategoryName, Description, ParentCategoryID, CreatedBy) VALUES
('Electronics', 'Electronic devices and accessories', NULL, 1),
('Clothing', 'Fashion and apparel', NULL, 1),
('Books', 'Books and publications', NULL, 1),
('Home & Garden', 'Home improvement and gardening supplies', NULL, 1),
('Sports & Outdoors', 'Sports equipment and outdoor gear', NULL, 1);


INSERT INTO Categories (CategoryName, Description, ParentCategoryID, CreatedBy) VALUES
('Laptops', 'Portable computers', 1, 2),
('Smartphones', 'Mobile phones and accessories', 1, 2),
('Tablets', 'Tablet computers', 1, 2),
('Accessories', 'Electronic accessories', 1, 2);


INSERT INTO Categories (CategoryName, Description, ParentCategoryID, CreatedBy) VALUES
('Men\'s Clothing', 'Clothing for men', 2, 1),
('Women\'s Clothing', 'Clothing for women', 2, 1),
('Shoes', 'Footwear', 2, 1),
('Bags & Accessories', 'Fashion accessories', 2, 2);


INSERT INTO Categories (CategoryName, Description, ParentCategoryID, CreatedBy) VALUES
('Fiction', 'Fiction books', 3, 1),
('Non-Fiction', 'Non-fiction books', 3, 1),
('Educational', 'Educational and academic books', 3, 2),
('Children\'s Books, 'Books for children', 3, 2);


INSERT INTO Categories (CategoryName, Description, ParentCategoryID, CreatedBy) VALUES
('Furniture', 'Home furniture', 4, 1),
('Kitchen', 'Kitchen supplies', 4, 2),
('Garden Tools', 'Gardening equipment', 4, 1),
('Decor', 'Home decoration', 4, 2);


INSERT INTO Categories (CategoryName, Description, ParentCategoryID, CreatedBy) VALUES
('Fitness', 'Fitness equipment', 5, 1),
('Outdoor Recreation', 'Outdoor activities gear', 5, 2),
('Team Sports', 'Team sports equipment', 5, 1),
('Athletic Wear', 'Sports clothing', 5, 2);



INSERT INTO Catalogs (SellerID, CatalogName, Description, IsActive) VALUES
(3, 'TechStore Premium Catalog', 'Latest electronics and gadgets', TRUE),
(4, 'FashionHub Collection', 'Trendy fashion and accessories', TRUE),
(5, 'BookWorld Library', 'Wide selection of books', TRUE),
(6, 'HomeGarden Essentials', 'Everything for your home and garden', TRUE),
(7, 'SportsGear Pro', 'Professional sports equipment', TRUE);



INSERT INTO Products (CategoryID, CatalogID, ProductName, Description, Price, StockQuantity, SKU, IsActive) VALUES
(6, 1, 'Dell XPS 15 Laptop', 'High-performance laptop with Intel i7, 16GB RAM, 512GB SSD', 45999.99, 15, 'TECH-LAP-001', TRUE),
(6, 1, 'MacBook Air M2', 'Apple MacBook Air with M2 chip, 8GB RAM, 256GB SSD', 52999.99, 10, 'TECH-LAP-002', TRUE),
(7, 1, 'iPhone 15 Pro', 'Latest iPhone with A17 Pro chip, 128GB storage', 54999.99, 25, 'TECH-PHN-001', TRUE),
(7, 1, 'Samsung Galaxy S24', 'Android flagship phone with 256GB storage', 42999.99, 30, 'TECH-PHN-002', TRUE),
(8, 1, 'iPad Pro 12.9"', 'Apple iPad Pro with M2 chip, 256GB', 38999.99, 12, 'TECH-TAB-001', TRUE),
(9, 1, 'Wireless Mouse', 'Ergonomic wireless mouse with USB receiver', 799.99, 100, 'TECH-ACC-001', TRUE),
(9, 1, 'Mechanical Keyboard', 'RGB mechanical gaming keyboard', 2499.99, 45, 'TECH-ACC-002', TRUE),
(9, 1, 'USB-C Hub 7-in-1', 'Multi-port USB-C hub with HDMI, USB 3.0', 1299.99, 60, 'TECH-ACC-003', TRUE);


INSERT INTO Products (CategoryID, CatalogID, ProductName, Description, Price, StockQuantity, SKU, IsActive) VALUES
(10, 2, 'Men\'s Cotton T-Shirt', 'Comfortable cotton t-shirt, various colors', 299.99, 200, 'FASH-MEN-001', TRUE),
(10, 2, 'Men\'s Denim Jeans', 'Classic fit denim jeans', 899.99, 150, 'FASH-MEN-002', TRUE),
(11, 2, 'Women\'s Summer Dress', 'Elegant floral summer dress', 1299.99, 80, 'FASH-WOM-001', TRUE),
(11, 2, 'Women\'s Blouse', 'Professional work blouse', 699.99, 120, 'FASH-WOM-002', TRUE),
(12, 2, 'Leather Sneakers', 'Comfortable leather sneakers for daily wear', 1899.99, 90, 'FASH-SHO-001', TRUE),
(12, 2, 'Running Shoes', 'Professional running shoes with cushioning', 2499.99, 70, 'FASH-SHO-002', TRUE),
(13, 2, 'Leather Handbag', 'Premium leather handbag', 3499.99, 40, 'FASH-BAG-001', TRUE),
(13, 2, 'Fashion Sunglasses', 'UV protection designer sunglasses', 899.99, 100, 'FASH-ACC-001', TRUE);


INSERT INTO Products (CategoryID, CatalogID, ProductName, Description, Price, StockQuantity, SKU, IsActive) VALUES
(14, 3, 'The Great Gatsby', 'Classic novel by F. Scott Fitzgerald', 149.99, 50, 'BOOK-FIC-001', TRUE),
(14, 3, '1984 by George Orwell', 'Dystopian fiction masterpiece', 159.99, 60, 'BOOK-FIC-002', TRUE),
(15, 3, 'Sapiens', 'A Brief History of Humankind by Yuval Noah Harari', 249.99, 45, 'BOOK-NON-001', TRUE),
(15, 3, 'Atomic Habits', 'Tiny Changes, Remarkable Results by James Clear', 199.99, 70, 'BOOK-NON-002', TRUE),
(16, 3, 'Database Systems', 'Comprehensive guide to database management', 599.99, 30, 'BOOK-EDU-001', TRUE),
(16, 3, 'Data Structures & Algorithms', 'Complete guide with examples', 549.99, 35, 'BOOK-EDU-002', TRUE),
(17, 3, 'Harry Potter Box Set', 'Complete Harry Potter series', 1299.99, 25, 'BOOK-CHI-001', TRUE),
(17, 3, 'The Little Prince', 'Classic children\'s book, 89.99, 80, 'BOOK-CHI-002', TRUE);


INSERT INTO Products (CategoryID, CatalogID, ProductName, Description, Price, StockQuantity, SKU, IsActive) VALUES
(18, 4, 'Modern Office Chair', 'Ergonomic office chair with lumbar support', 3999.99, 20, 'HOME-FUR-001', TRUE),
(18, 4, 'Bookshelf 5-Tier', 'Wooden bookshelf with 5 tiers', 2499.99, 15, 'HOME-FUR-002', TRUE),
(19, 4, 'Non-Stick Cookware Set', '10-piece non-stick cookware set', 1899.99, 40, 'HOME-KIT-001', TRUE),
(19, 4, 'Electric Kettle', '1.7L stainless steel electric kettle', 599.99, 60, 'HOME-KIT-002', TRUE),
(20, 4, 'Garden Hose 50ft', 'Durable garden hose with spray nozzle', 449.99, 50, 'HOME-GAR-001', TRUE),
(20, 4, 'Pruning Shears', 'Professional pruning shears', 299.99, 70, 'HOME-GAR-002', TRUE),
(21, 4, 'Wall Art Canvas Set', 'Modern abstract canvas art set of 3', 899.99, 35, 'HOME-DEC-001', TRUE),
(21, 4, 'Table Lamp', 'Modern LED table lamp', 699.99, 45, 'HOME-DEC-002', TRUE);


INSERT INTO Products (CategoryID, CatalogID, ProductName, Description, Price, StockQuantity, SKU, IsActive) VALUES
(22, 5, 'Adjustable Dumbbells', 'Set of adjustable dumbbells 5-25kg', 2999.99, 25, 'SPRT-FIT-001', TRUE),
(22, 5, 'Yoga Mat Premium', 'Extra thick yoga mat with carrying strap', 599.99, 80, 'SPRT-FIT-002', TRUE),
(23, 5, 'Camping Tent 4-Person', 'Waterproof camping tent for 4 people', 3499.99, 15, 'SPRT-OUT-001', TRUE),
(23, 5, 'Hiking Backpack 50L', 'Durable hiking backpack with rain cover', 1899.99, 30, 'SPRT-OUT-002', TRUE),
(24, 5, 'Basketball Official Size', 'Official size basketball', 599.99, 50, 'SPRT-TEA-001', TRUE),
(24, 5, 'Soccer Ball', 'Professional soccer ball', 549.99, 60, 'SPRT-TEA-002', TRUE),
(25, 5, 'Men\s Sports Shorts', 'Quick-dry athletic shorts', 399.99, 100, 'SPRT-ATH-001', TRUE),
(25, 5, 'Compression Shirt', 'Performance compression shirt', 699.99, 80, 'SPRT-ATH-002', TRUE);



INSERT INTO Orders (CustomerID, SellerID, ShippingAddressID, BillingAddressID, OrderStatus, OrderDate) VALUES
(8, 3, 1, 1, 'Delivered', '2025-10-15 10:30:00');


INSERT INTO Orders (CustomerID, SellerID, ShippingAddressID, BillingAddressID, OrderStatus, OrderDate) VALUES
(9, 4, 3, 3, 'Delivered', '2025-10-18 14:20:00');


INSERT INTO Orders (CustomerID, SellerID, ShippingAddressID, BillingAddressID, OrderStatus, OrderDate) VALUES
(10, 5, 4, 5, 'Shipped', '2025-11-01 09:15:00');


INSERT INTO Orders (CustomerID, SellerID, ShippingAddressID, BillingAddressID, OrderStatus, OrderDate) VALUES
(11, 6, 6, 6, 'Processing', '2025-11-05 16:45:00');


INSERT INTO Orders (CustomerID, SellerID, ShippingAddressID, BillingAddressID, OrderStatus, OrderDate) VALUES
(12, 7, 7, 7, 'Confirmed', '2025-11-10 11:30:00');


INSERT INTO Orders (CustomerID, SellerID, ShippingAddressID, BillingAddressID, OrderStatus, OrderDate) VALUES
(13, 3, 8, 8, 'Pending', '2025-11-12 13:00:00');


INSERT INTO Orders (CustomerID, SellerID, ShippingAddressID, BillingAddressID, OrderStatus, OrderDate) VALUES
(14, 4, 9, 9, 'Delivered', '2025-10-25 15:20:00');


INSERT INTO Orders (CustomerID, SellerID, ShippingAddressID, BillingAddressID, OrderStatus, OrderDate) VALUES
(15, 5, 10, 10, 'Shipped', '2025-11-08 10:00:00');


INSERT INTO Orders (CustomerID, SellerID, ShippingAddressID, BillingAddressID, OrderStatus, OrderDate) VALUES
(8, 4, 1, 1, 'Delivered', '2025-10-20 12:30:00');


INSERT INTO Orders (CustomerID, SellerID, ShippingAddressID, BillingAddressID, OrderStatus, OrderDate) VALUES
(9, 7, 3, 3, 'Processing', '2025-11-11 09:45:00');




INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice) VALUES
(1, 1, 1, 45999.99),  
(1, 6, 2, 799.99);     


INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice) VALUES
(2, 9, 3, 299.99),     
(2, 10, 1, 899.99);    


INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice) VALUES
(3, 19, 2, 149.99),    
(3, 21, 1, 249.99),    
(3, 22, 1, 199.99);    


INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice) VALUES
(4, 25, 1, 3999.99),   
(4, 27, 1, 1899.99);   


INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice) VALUES
(5, 33, 1, 2999.99),   
(5, 34, 2, 599.99);    


INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice) VALUES
(6, 3, 1, 54999.99),   
(6, 8, 1, 1299.99);    


INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice) VALUES
(7, 11, 2, 1299.99),   
(7, 15, 1, 3499.99);   


INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice) VALUES
(8, 23, 1, 599.99),    
(8, 24, 1, 549.99);    


INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice) VALUES
(9, 13, 1, 1899.99),   
(9, 16, 1, 899.99);    


INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice) VALUES
(10, 37, 1, 599.99),   
(10, 39, 3, 399.99);   



INSERT INTO Payments (OrderID, PaymentMethod, PaymentAmount, PaymentStatus, TransactionID, PaymentDate) VALUES
(1, 'Credit Card', 47599.97, 'Completed', 'TXN-2025-10-15-001', '2025-10-15 10:35:00'),
(2, 'Debit Card', 1799.96, 'Completed', 'TXN-2025-10-18-002', '2025-10-18 14:25:00'),
(3, 'Bank Transfer', 749.96, 'Completed', 'TXN-2025-11-01-003', '2025-11-01 09:20:00'),
(4, 'Credit Card', 5899.98, 'Completed', 'TXN-2025-11-05-004', '2025-11-05 16:50:00'),
(5, 'Wallet', 4199.97, 'Completed', 'TXN-2025-11-10-005', '2025-11-10 11:35:00'),
(6, 'Credit Card', 56299.98, 'Pending', 'TXN-2025-11-12-006', '2025-11-12 13:05:00'),
(7, 'Credit Card', 6099.97, 'Completed', 'TXN-2025-10-25-007', '2025-10-25 15:25:00'),
(8, 'Debit Card', 1149.98, 'Completed', 'TXN-2025-11-08-008', '2025-11-08 10:05:00'),
(9, 'Credit Card', 2799.98, 'Completed', 'TXN-2025-10-20-009', '2025-10-20 12:35:00'),
(10, 'Bank Transfer', 1799.96, 'Completed', 'TXN-2025-11-11-010', '2025-11-11 09:50:00');



INSERT INTO Shipments (OrderID, TrackingNumber, ShipmentStatus, ShippedDate, EstimatedDelivery, ActualDelivery, Carrier) VALUES
(1, 'TRK-IST-2025-001', 'Delivered', '2025-10-16 09:00:00', '2025-10-20', '2025-10-19 14:30:00', 'Aras Kargo'),
(2, 'TRK-ANK-2025-002', 'Delivered', '2025-10-19 10:00:00', '2025-10-23', '2025-10-22 16:20:00', 'MNG Kargo'),
(3, 'TRK-IZM-2025-003', 'In Transit', '2025-11-02 08:30:00', '2025-11-16', NULL, 'Yurtiçi Kargo'),
(4, 'TRK-BRS-2025-004', 'Preparing', NULL, '2025-11-20', NULL, 'PTT Kargo'),
(5, 'TRK-ANT-2025-005', 'Preparing', NULL, '2025-11-25', NULL, 'Sürat Kargo'),
(6, 'TRK-IZM-2025-006', 'Preparing', NULL, '2025-11-28', NULL, 'Aras Kargo'),
(7, 'TRK-IST-2025-007', 'Delivered', '2025-10-26 11:00:00', '2025-10-30', '2025-10-29 15:45:00', 'MNG Kargo'),
(8, 'TRK-ANK-2025-008', 'Shipped', '2025-11-09 09:00:00', '2025-11-18', NULL, 'Yurtiçi Kargo'),
(9, 'TRK-IST-2025-009', 'Delivered', '2025-10-21 10:30:00', '2025-10-25', '2025-10-24 13:20:00', 'Aras Kargo'),
(10, 'TRK-ANK-2025-010', 'Preparing', NULL, '2025-11-22', NULL, 'PTT Kargo');




INSERT INTO Reviews (CustomerID, ProductID, OrderItemID, Rating, ReviewText, ReviewDate) VALUES
(8, 1, 1, 5, 'Excellent laptop! Very fast and perfect for my work. Highly recommend!', '2025-10-20 10:00:00'),
(8, 6, 2, 4, 'Good wireless mouse, comfortable to use but battery life could be better.', '2025-10-20 10:15:00');


INSERT INTO Reviews (CustomerID, ProductID, OrderItemID, Rating, ReviewText, ReviewDate) VALUES
(9, 9, 3, 5, 'Great quality t-shirts! Fabric is soft and comfortable. Will buy again.', '2025-10-23 14:30:00'),
(9, 10, 4, 4, 'Nice jeans, good fit. The color is slightly different from the photo.', '2025-10-23 14:45:00');


INSERT INTO Reviews (CustomerID, ProductID, OrderItemID, Rating, ReviewText, ReviewDate) VALUES
(14, 11, 13, 5, 'Beautiful summer dress! Perfect fit and the fabric quality is amazing.', '2025-10-30 11:20:00'),
(14, 15, 14, 5, 'Luxurious leather handbag! Worth every penny. Love it!', '2025-10-30 11:35:00');


INSERT INTO Reviews (CustomerID, ProductID, OrderItemID, Rating, ReviewText, ReviewDate) VALUES
(8, 13, 15, 4, 'Comfortable sneakers, good for daily wear. Took a few days to break in.', '2025-10-25 16:00:00'),
(8, 16, 16, 5, 'Stylish sunglasses with great UV protection. Very happy with purchase!', '2025-10-25 16:10:00');


UPDATE Orders SET TotalAmount = 47599.97 WHERE OrderID = 1;
UPDATE Orders SET TotalAmount = 1799.96 WHERE OrderID = 2;
UPDATE Orders SET TotalAmount = 749.96 WHERE OrderID = 3;
UPDATE Orders SET TotalAmount = 5899.98 WHERE OrderID = 4;
UPDATE Orders SET TotalAmount = 4199.97 WHERE OrderID = 5;
UPDATE Orders SET TotalAmount = 56299.98 WHERE OrderID = 6;
UPDATE Orders SET TotalAmount = 6099.97 WHERE OrderID = 7;
UPDATE Orders SET TotalAmount = 1149.98 WHERE OrderID = 8;
UPDATE Orders SET TotalAmount = 2799.98 WHERE OrderID = 9;
UPDATE Orders SET TotalAmount = 1799.96 WHERE OrderID = 10;



INSERT INTO Products (CategoryID, CatalogID, ProductName, Description, Price, StockQuantity, SKU, IsActive) VALUES
(7, 1, 'Google Pixel 8', 'Google flagship with AI features, 128GB', 39999.99, 20, 'TECH-PHN-003', TRUE),
(8, 1, 'Samsung Galaxy Tab S9', 'Android tablet with S Pen, 128GB', 25999.99, 18, 'TECH-TAB-002', TRUE),
(9, 1, '4K Webcam', 'Professional 4K webcam with auto-focus', 3499.99, 35, 'TECH-ACC-004', TRUE);


INSERT INTO Products (CategoryID, CatalogID, ProductName, Description, Price, StockQuantity, SKU, IsActive) VALUES
(10, 2, 'Men\'s Formal Shirt', 'Classic white formal shirt', 599.99, 85, 'FASH-MEN-003', TRUE),
(11, 2, 'Women\'s Cardigan', 'Cozy knit cardigan', 899.99, 65, 'FASH-WOM-003', TRUE),
(12, 2, 'Winter Boots', 'Waterproof winter boots', 2999.99, 45, 'FASH-SHO-003', TRUE);


INSERT INTO Products (CategoryID, CatalogID, ProductName, Description, Price, StockQuantity, SKU, IsActive) VALUES
(14, 3, 'To Kill a Mockingbird', 'Classic American novel', 139.99, 55, 'BOOK-FIC-003', TRUE),
(15, 3, 'Thinking, Fast and Slow', 'Psychology and behavioral economics', 229.99, 40, 'BOOK-NON-003', TRUE),
(16, 3, 'Introduction to Algorithms', 'MIT Press classic textbook', 799.99, 25, 'BOOK-EDU-003', TRUE);


INSERT INTO Products (CategoryID, CatalogID, ProductName, Description, Price, StockQuantity, SKU, IsActive) VALUES
(18, 4, 'Standing Desk', 'Adjustable height standing desk', 6999.99, 12, 'HOME-FUR-003', TRUE),
(19, 4, 'Blender 1000W', 'High-power blender for smoothies', 1299.99, 30, 'HOME-KIT-003', TRUE),
(20, 4, 'Lawn Mower Electric', 'Cordless electric lawn mower', 4999.99, 8, 'HOME-GAR-003', TRUE);


INSERT INTO Products (CategoryID, CatalogID, ProductName, Description, Price, StockQuantity, SKU, IsActive) VALUES
(22, 5, 'Resistance Bands Set', 'Set of 5 resistance bands with handles', 799.99, 75, 'SPRT-FIT-003', TRUE),
(23, 5, 'Sleeping Bag', 'All-season sleeping bag', 1499.99, 22, 'SPRT-OUT-003', TRUE),
(24, 5, 'Volleyball', 'Official size volleyball', 499.99, 55, 'SPRT-TEA-003', TRUE);




SET FOREIGN_KEY_CHECKS = 1;



SELECT '=== DATABASE POPULATION SUMMARY ===' AS '';

SELECT 'Users' AS Table_Name, COUNT(*) AS Record_Count FROM Users
UNION ALL
SELECT 'Addresses', COUNT(*) FROM Addresses
UNION ALL
SELECT 'Categories', COUNT(*) FROM Categories
UNION ALL
SELECT 'Catalogs', COUNT(*) FROM Catalogs
UNION ALL
SELECT 'Products', COUNT(*) FROM Products
UNION ALL
SELECT 'Orders', COUNT(*) FROM Orders
UNION ALL
SELECT 'OrderItems', COUNT(*) FROM OrderItems
UNION ALL
SELECT 'Payments', COUNT(*) FROM Payments
UNION ALL
SELECT 'Shipments', COUNT(*) FROM Shipments
UNION ALL
SELECT 'Reviews', COUNT(*) FROM Reviews;


SELECT 
    '=== USER ROLE DISTRIBUTION ===' AS '';
    
SELECT 
    Role,
    COUNT(*) AS Count,
    CONCAT(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Users), 1), '%') AS Percentage
FROM Users
GROUP BY Role
ORDER BY Count DESC;


SELECT 
    '=== ORDER STATUS DISTRIBUTION ===' AS '';
    
SELECT 
    OrderStatus,
    COUNT(*) AS Count,
    CONCAT('₺', FORMAT(SUM(TotalAmount), 2)) AS Total_Value
FROM Orders
GROUP BY OrderStatus
ORDER BY Count DESC;


SELECT 
    '=== TOP 5 PRODUCTS BY QUANTITY SOLD ===' AS '';
    
SELECT 
    p.ProductName,
    SUM(oi.Quantity) AS Total_Quantity_Sold,
    CONCAT('₺', FORMAT(SUM(oi.Subtotal), 2)) AS Total_Revenue
FROM Products p
JOIN OrderItems oi ON p.ProductID = oi.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY Total_Quantity_Sold DESC
LIMIT 5;


SELECT 
    '=== SELLER PERFORMANCE ===' AS '';
    
SELECT 
    CONCAT(u.FirstName, ' ', u.LastName) AS Seller_Name,
    COUNT(DISTINCT o.OrderID) AS Total_Orders,
    CONCAT('₺', FORMAT(SUM(o.TotalAmount), 2)) AS Total_Sales,
    COUNT(DISTINCT p.ProductID) AS Products_Listed
FROM Users u
JOIN Catalogs c ON u.UserID = c.SellerID
LEFT JOIN Products p ON c.CatalogID = p.CatalogID
LEFT JOIN Orders o ON u.UserID = o.SellerID
WHERE u.Role = 'Seller'
GROUP BY u.UserID, u.FirstName, u.LastName
ORDER BY Total_Sales DESC;


SELECT 
    '=== MOST ACTIVE CUSTOMERS ===' AS '';
    
SELECT 
    CONCAT(u.FirstName, ' ', u.LastName) AS Customer_Name,
    COUNT(o.OrderID) AS Total_Orders,
    CONCAT('₺', FORMAT(SUM(o.TotalAmount), 2)) AS Total_Spent,
    COUNT(r.ReviewID) AS Reviews_Written
FROM Users u
LEFT JOIN Orders o ON u.UserID = o.CustomerID
LEFT JOIN Reviews r ON u.UserID = r.CustomerID
WHERE u.Role = 'Customer'
GROUP BY u.UserID, u.FirstName, u.LastName
ORDER BY Total_Orders DESC;


SELECT 
    '=== PRODUCTS PER CATEGORY ===' AS '';
    
SELECT 
    c.CategoryName,
    COUNT(p.ProductID) AS Product_Count,
    CONCAT('₺', FORMAT(AVG(p.Price), 2)) AS Avg_Price,
    SUM(p.StockQuantity) AS Total_Stock
FROM Categories c
LEFT JOIN Products p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryID, c.CategoryName
HAVING Product_Count > 0
ORDER BY Product_Count DESC;


SELECT 
    '=== PAYMENT METHODS USED ===' AS '';
    
SELECT 
    PaymentMethod,
    COUNT(*) AS Transaction_Count,
    CONCAT('₺', FORMAT(SUM(PaymentAmount), 2)) AS Total_Amount,
    CONCAT(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Payments), 1), '%') AS Usage_Percentage
FROM Payments
GROUP BY PaymentMethod
ORDER BY Transaction_Count DESC;


SELECT 
    '=== SHIPMENT STATUS OVERVIEW ===' AS '';
    
SELECT 
    ShipmentStatus,
    COUNT(*) AS Count,
    Carrier,
    COUNT(*) AS Shipments_Per_Carrier
FROM Shipments
GROUP BY ShipmentStatus, Carrier
ORDER BY ShipmentStatus, Shipments_Per_Carrier DESC;


SELECT 
    '=== AVERAGE RATINGS BY CATEGORY ===' AS '';
    
SELECT 
    c.CategoryName,
    COUNT(r.ReviewID) AS Total_Reviews,
    ROUND(AVG(r.Rating), 2) AS Average_Rating,
    MIN(r.Rating) AS Min_Rating,
    MAX(r.Rating) AS Max_Rating
FROM Categories c
JOIN Products p ON c.CategoryID = p.CategoryID
JOIN Reviews r ON p.ProductID = r.ProductID
GROUP BY c.CategoryID, c.CategoryName
ORDER BY Average_Rating DESC;


SELECT 
    '=== LOW STOCK ALERT (Less than 20 units) ===' AS '';
    
SELECT 
    p.ProductName,
    p.StockQuantity,
    CONCAT(u.FirstName, ' ', u.LastName) AS Seller_Name,
    c.CategoryName
FROM Products p
JOIN Catalogs cat ON p.CatalogID = cat.CatalogID
JOIN Users u ON cat.SellerID = u.UserID
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE p.StockQuantity < 20 AND p.IsActive = TRUE
ORDER BY p.StockQuantity ASC;


SELECT 
    '=== RECENT ACTIVITY (Last 7 Days) ===' AS '';
    
SELECT 
    'New Orders' AS Activity_Type,
    COUNT(*) AS Count
FROM Orders
WHERE OrderDate >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
UNION ALL
SELECT 
    'New Reviews',
    COUNT(*)
FROM Reviews
WHERE ReviewDate >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
UNION ALL
SELECT 
    'Completed Payments',
    COUNT(*)
FROM Payments
WHERE PaymentDate >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) AND PaymentStatus = 'Completed';



SELECT 
    '=== SAMPLE QUERIES FOR TESTING ===' AS '';


SELECT 
    'Query 1: Electronics products with stock > 10' AS Query_Description;
    
SELECT 
    p.ProductName,
    p.Price,
    p.StockQuantity,
    CONCAT(u.FirstName, ' ', u.LastName) AS Seller
FROM Products p
JOIN Catalogs c ON p.CatalogID = c.CatalogID
JOIN Users u ON c.SellerID = u.UserID
JOIN Categories cat ON p.CategoryID = cat.CategoryID
WHERE cat.CategoryName = 'Electronics' 
  AND p.StockQuantity > 10
  AND p.IsActive = TRUE
ORDER BY p.Price DESC
LIMIT 5;


SELECT 
    'Query 2: Complete order history for Alice' AS Query_Description;
    
SELECT 
    o.OrderID,
    o.OrderDate,
    o.OrderStatus,
    p.ProductName,
    oi.Quantity,
    oi.UnitPrice,
    oi.Subtotal,
    pay.PaymentStatus,
    s.ShipmentStatus
FROM Orders o
JOIN Users u ON o.CustomerID = u.UserID
JOIN OrderItems oi ON o.OrderID = oi.OrderID
JOIN Products p ON oi.ProductID = p.ProductID
LEFT JOIN Payments pay ON o.OrderID = pay.OrderID
LEFT JOIN Shipments s ON o.OrderID = s.OrderID
WHERE u.Username = 'customer_alice'
ORDER BY o.OrderDate DESC;


SELECT 
    'Query 3: Highly rated products (4+ stars)' AS Query_Description;
    
SELECT 
    p.ProductName,
    c.CategoryName,
    ROUND(AVG(r.Rating), 2) AS Avg_Rating,
    COUNT(r.ReviewID) AS Review_Count,
    p.Price
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
JOIN Reviews r ON p.ProductID = r.ProductID
GROUP BY p.ProductID, p.ProductName, c.CategoryName, p.Price
HAVING Avg_Rating >= 4
ORDER BY Avg_Rating DESC, Review_Count DESC
LIMIT 5;


SELECT 
    '============================================' AS '',
    'DATABASE SUCCESSFULLY POPULATED!' AS '',
    '============================================' AS '';

SELECT 
    'Total Records Inserted:' AS Summary,
    (SELECT COUNT(*) FROM Users) + 
    (SELECT COUNT(*) FROM Addresses) + 
    (SELECT COUNT(*) FROM Categories) + 
    (SELECT COUNT(*) FROM Catalogs) + 
    (SELECT COUNT(*) FROM Products) + 
    (SELECT COUNT(*) FROM Orders) + 
    (SELECT COUNT(*) FROM OrderItems) + 
    (SELECT COUNT(*) FROM Payments) + 
    (SELECT COUNT(*) FROM Shipments) + 
    (SELECT COUNT(*) FROM Reviews) AS Count;

SELECT 'The database is ready for testing and demonstration!' AS Message;


INSERT IGNORE INTO Coupons (Code, DiscountPercent, ExpiryDate) VALUES 
('NEWYEAR2026', 15, '2026-01-10'),
('WELCOME', 10, '2030-12-31'),
('SPRING2026', 20, '2026-05-01');