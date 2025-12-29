DROP DATABASE IF EXISTS ecommerce_db;
CREATE DATABASE ecommerce_db;
USE ecommerce_db;

-- Users Table
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('Customer', 'Seller', 'Administrator') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    CONSTRAINT chk_email_format CHECK (email LIKE '%@%.%')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Addresses Table
CREATE TABLE Addresses (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    street VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    address_type ENUM('Shipping', 'Billing', 'Both') DEFAULT 'Both',
    is_default BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    INDEX idx_user_addresses (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Categories Table
CREATE TABLE Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    parent_category_id INT DEFAULT NULL,
    description TEXT,
    created_by INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_category_id) REFERENCES Categories(category_id) ON DELETE SET NULL,
    FOREIGN KEY (created_by) REFERENCES Users(user_id) ON DELETE RESTRICT,
    INDEX idx_parent_category (parent_category_id),
    CONSTRAINT chk_admin_creator CHECK (
        created_by IN (SELECT user_id FROM Users WHERE role = 'Administrator')
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Catalogs Table
CREATE TABLE Catalogs (
    catalog_id INT AUTO_INCREMENT PRIMARY KEY,
    seller_id INT UNIQUE NOT NULL,
    catalog_name VARCHAR(150) NOT NULL,
    description TEXT,
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (seller_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    CONSTRAINT chk_seller_role CHECK (
        seller_id IN (SELECT user_id FROM Users WHERE role = 'Seller')
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Products Table
CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    catalog_id INT NOT NULL,
    category_id INT NOT NULL,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    image_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (catalog_id) REFERENCES Catalogs(catalog_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id) ON DELETE RESTRICT,
    CONSTRAINT chk_price_positive CHECK (price >= 0),
    CONSTRAINT chk_stock_non_negative CHECK (stock_quantity >= 0),
    INDEX idx_catalog_products (catalog_id),
    INDEX idx_category_products (category_id),
    INDEX idx_product_search (name, category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Orders Table
-- Note: Using both shipping and billing addresses for realistic e-commerce
-- Guide shows single address_id, but dual addresses are more practical
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    seller_id INT NOT NULL,
    shipping_address_id INT NOT NULL,
    billing_address_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    status ENUM('Pending', 'Paid', 'Shipped', 'Delivered', 'Canceled') DEFAULT 'Pending',
    notes TEXT,
    FOREIGN KEY (customer_id) REFERENCES Users(user_id) ON DELETE RESTRICT,
    FOREIGN KEY (seller_id) REFERENCES Users(user_id) ON DELETE RESTRICT,
    FOREIGN KEY (shipping_address_id) REFERENCES Addresses(address_id) ON DELETE RESTRICT,
    FOREIGN KEY (billing_address_id) REFERENCES Addresses(address_id) ON DELETE RESTRICT,
    CONSTRAINT chk_customer_role CHECK (
        customer_id IN (SELECT user_id FROM Users WHERE role = 'Customer')
    ),
    CONSTRAINT chk_total_positive CHECK (total_amount >= 0),
    INDEX idx_customer_orders (customer_id),
    INDEX idx_order_status (status),
    INDEX idx_order_date (order_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Order_Items Table
CREATE TABLE Order_Items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price_at_purchase DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) GENERATED ALWAYS AS (quantity * price_at_purchase) STORED,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE RESTRICT,
    UNIQUE KEY uk_order_product (order_id, product_id),
    CONSTRAINT chk_quantity_positive CHECK (quantity > 0),
    CONSTRAINT chk_price_at_purchase_positive CHECK (price_at_purchase >= 0),
    INDEX idx_order_items (order_id),
    INDEX idx_product_orders (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Payments Table
CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10, 2) NOT NULL,
    method ENUM('Credit Card', 'Debit Card', 'PayPal', 'Bank Transfer', 'Wallet') NOT NULL,
    transaction_id VARCHAR(100) UNIQUE,
    status ENUM('Pending', 'Completed', 'Failed', 'Refunded') DEFAULT 'Pending',
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE RESTRICT,
    CONSTRAINT chk_payment_amount_positive CHECK (amount > 0),
    INDEX idx_order_payments (order_id),
    INDEX idx_transaction (transaction_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Shipments Table
CREATE TABLE Shipments (
    shipment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT UNIQUE NOT NULL,
    tracking_number VARCHAR(100) UNIQUE,
    shipped_date DATE,
    estimated_delivery_date DATE,
    actual_delivery_date DATE,
    carrier VARCHAR(100),
    status ENUM('Preparing', 'Shipped', 'In Transit', 'Out for Delivery', 'Delivered') DEFAULT 'Preparing',
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE RESTRICT,
    CONSTRAINT chk_delivery_dates CHECK (
        actual_delivery_date IS NULL OR 
        actual_delivery_date >= shipped_date
    ),
    INDEX idx_tracking (tracking_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Reviews Table
CREATE TABLE Reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    order_id INT NOT NULL,
    order_item_id INT UNIQUE NOT NULL,
    rating INT NOT NULL,
    comment TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (order_item_id) REFERENCES Order_Items(order_item_id) ON DELETE CASCADE,
    CONSTRAINT chk_rating_range CHECK (rating BETWEEN 1 AND 5),
    CONSTRAINT chk_customer_role CHECK (
        customer_id IN (SELECT user_id FROM Users WHERE role = 'Customer')
    ),
    INDEX idx_product_reviews (product_id),
    INDEX idx_customer_reviews (customer_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Wishlists Table (Additional Feature)
CREATE TABLE Wishlists (
    wishlist_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    added_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_user_product (user_id, product_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Notifications Table (Additional Feature)
CREATE TABLE Notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    message TEXT NOT NULL,
    read_status BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Coupons Table (Additional Feature)
CREATE TABLE Coupons (
    coupon_id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    discount_percent INT NOT NULL CHECK (discount_percent > 0 AND discount_percent <= 100),
    expiry_date DATE NOT NULL,
    min_order_amount DECIMAL(10,2) DEFAULT 0.00,
    is_active BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create indexes for better performance
CREATE INDEX idx_users_email ON Users(email);
CREATE INDEX idx_users_role ON Users(role);
CREATE INDEX idx_addresses_user ON Addresses(user_id);
CREATE INDEX idx_products_catalog ON Products(catalog_id);
CREATE INDEX idx_products_category ON Products(category_id);
CREATE INDEX idx_orders_customer ON Orders(customer_id);
CREATE INDEX idx_orders_seller ON Orders(seller_id);
CREATE INDEX idx_orders_status ON Orders(status);
CREATE INDEX idx_order_items_order ON Order_Items(order_id);
CREATE INDEX idx_order_items_product ON Order_Items(product_id);
CREATE INDEX idx_payments_order ON Payments(order_id);
CREATE INDEX idx_shipments_order ON Shipments(order_id);
CREATE INDEX idx_reviews_product ON Reviews(product_id);
CREATE INDEX idx_reviews_customer ON Reviews(customer_id);

SELECT 'Database schema created successfully!' AS Message;
