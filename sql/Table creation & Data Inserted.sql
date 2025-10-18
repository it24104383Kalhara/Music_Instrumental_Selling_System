USE music_store
GO

-- 1. First create app_user table (no dependencies)
CREATE TABLE dbo.app_user (
    id INT IDENTITY(1,1) PRIMARY KEY,
    email NVARCHAR(255) NOT NULL UNIQUE,
    password NVARCHAR(100) NOT NULL,
    full_name NVARCHAR(100) NOT NULL,
    role NVARCHAR(20) NOT NULL DEFAULT 'Customer',
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

-- 2. Create instrument table (no dependencies on other custom tables)
CREATE TABLE dbo.instrument (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(1000) NULL,
    price DECIMAL(10,2) NOT NULL,
    in_stock BIT NOT NULL DEFAULT 1,
    stock_quantity INT NOT NULL DEFAULT 0,
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

-- 3. Create customer_order table (depends on app_user)
CREATE TABLE dbo.customer_order (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    order_number NVARCHAR(40) NOT NULL UNIQUE,
    status NVARCHAR(20) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    updated_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    shipping_address NVARCHAR(500) NULL,
    CONSTRAINT FK_order_user FOREIGN KEY (user_id) REFERENCES dbo.app_user(id) ON DELETE CASCADE,
    CONSTRAINT CK_status CHECK (status IN (N'Processing', N'Shipped', N'Delivered', N'Cancelled'))
);
GO

-- 4. Create order_item table (depends on customer_order and instrument)
CREATE TABLE dbo.order_item (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    order_id BIGINT NOT NULL,
    instrument_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_order_item_order FOREIGN KEY (order_id) REFERENCES dbo.customer_order(id) ON DELETE CASCADE,
    CONSTRAINT FK_order_item_instrument FOREIGN KEY (instrument_id) REFERENCES dbo.instrument(id)
);
GO

-- 5. Create payment table (depends on customer_order and app_user)
CREATE TABLE dbo.payment (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    order_id BIGINT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method NVARCHAR(50) NOT NULL,
    payment_status NVARCHAR(20) NOT NULL DEFAULT 'Pending',
    transaction_id NVARCHAR(100) NULL,
    payment_date DATETIME2 NULL,
    is_verified BIT NOT NULL DEFAULT 0,
    verified_by INT NULL,
    verified_at DATETIME2 NULL,
    notes NVARCHAR(500) NULL,
    CONSTRAINT FK_payment_order FOREIGN KEY (order_id) REFERENCES dbo.customer_order(id),
    CONSTRAINT FK_payment_verified_by FOREIGN KEY (verified_by) REFERENCES dbo.app_user(id)
);
GO

-- 6. Create product_feedback table (depends on app_user, instrument, and customer_order)
CREATE TABLE dbo.product_feedback (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    instrument_id INT NOT NULL,
    order_id BIGINT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment NVARCHAR(1000) NULL,
    is_approved BIT NOT NULL DEFAULT 0,
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_feedback_user FOREIGN KEY (user_id) REFERENCES dbo.app_user(id),
    CONSTRAINT FK_feedback_instrument FOREIGN KEY (instrument_id) REFERENCES dbo.instrument(id),
    CONSTRAINT FK_feedback_order FOREIGN KEY (order_id) REFERENCES dbo.customer_order(id)
);
GO

-- Insert Admin user (only one admin)
INSERT INTO dbo.app_user (email, password, full_name, role) VALUES 
('admin@musicstore.com', 'admin123', 'System Administrator', 'Admin');

-- Insert Customer users
INSERT INTO dbo.app_user (email, password, full_name, role) VALUES 
('john@example.com', 'john123', 'John Smith', 'Customer'),
('sarah@example.com', 'sarah123', 'Sarah Johnson', 'Customer'),
('mike@example.com', 'mike123', 'Mike Brown', 'Customer'),
('student@example.com', 'student123', 'Student User', 'Customer');

-- Insert musical instruments
INSERT INTO dbo.instrument (name, description, price, in_stock, stock_quantity) VALUES 
('Acoustic Guitar', '6-string acoustic guitar, perfect for beginners', 199.99, 1, 15),
('Electric Guitar', 'Professional electric guitar with amplifier', 499.99, 1, 8),
('Digital Piano', '88-key digital piano with weighted keys', 899.99, 1, 5),
('Violin', '4/4 full size classical violin with bow', 299.99, 1, 12),
('Drum Set', '5-piece complete drum set with cymbals', 699.99, 1, 3),
('Bass Guitar', '4-string electric bass guitar', 349.99, 1, 7),
('Saxophone', 'Alto saxophone for intermediate players', 599.99, 1, 4),
('Keyboard', '61-key portable keyboard with stand', 199.99, 1, 10);


-- Insert orders with different statuses for tracking
INSERT INTO dbo.customer_order (user_id, order_number, status, total_amount, shipping_address) VALUES 
(2, 'ORD-2024-001', 'Processing', 199.99, '123 Main Street, New York, NY'),
(2, 'ORD-2024-002', 'Shipped', 899.99, '123 Main Street, New York, NY'),
(3, 'ORD-2024-003', 'Delivered', 299.99, '456 Oak Avenue, Los Angeles, CA'),
(3, 'ORD-2024-004', 'Processing', 1049.98, '456 Oak Avenue, Los Angeles, CA'),
(4, 'ORD-2024-005', 'Shipped', 699.99, '789 Pine Road, Chicago, IL'),
(5, 'ORD-2024-006', 'Delivered', 349.99, '321 Elm Street, Houston, TX'),
(5, 'ORD-2024-007', 'Processing', 199.99, '321 Elm Street, Houston, TX');


-- Insert order items
INSERT INTO dbo.order_item (order_id, instrument_id, quantity, unit_price) VALUES 
(1, 1, 1, 199.99),    -- John - Acoustic Guitar (Processing)
(2, 3, 1, 899.99),    -- John - Digital Piano (Shipped)
(3, 4, 1, 299.99),    -- Sarah - Violin (Delivered)
(4, 1, 1, 199.99),    -- Sarah - Acoustic Guitar + Keyboard (Processing)
(4, 8, 1, 199.99),    -- Sarah - Keyboard
(5, 5, 1, 699.99),    -- Mike - Drum Set (Shipped)
(6, 6, 1, 349.99),    -- Student - Bass Guitar (Delivered)
(7, 8, 1, 199.99);    -- Student - Keyboard (Processing)


-- Insert payment records
INSERT INTO dbo.payment (order_id, amount, payment_method, payment_status, is_verified) VALUES 
(1, 199.99, 'Credit Card', 'Completed', 1),
(2, 899.99, 'PayPal', 'Completed', 1),
(3, 299.99, 'Credit Card', 'Completed', 1),
(4, 1049.98, 'Bank Transfer', 'Pending', 0),
(5, 699.99, 'Credit Card', 'Completed', 1),
(6, 349.99, 'PayPal', 'Completed', 1),
(7, 199.99, 'Credit Card', 'Completed', 1);


-- Insert some product reviews
INSERT INTO dbo.product_feedback (user_id, instrument_id, order_id, rating, comment, is_approved) VALUES 
(3, 4, 3, 5, 'Excellent violin! Great sound quality and fast delivery.', 1),
(5, 6, 6, 4, 'Good bass guitar for the price. Would recommend for beginners.', 1),
(2, 3, 2, 5, 'Amazing digital piano! The weighted keys feel just like a real piano.', 1);


select * from dbo.app_user;
select * from dbo.customer_order;
select * from dbo.instrument;
select * from dbo.order_item;
select * from dbo.payment;
select * from dbo.product_feedback;

-- Add Staff user
INSERT INTO dbo.app_user (email, password, full_name, role) VALUES 
('staff@musicstore.com', 'staff123', 'Store Manager', 'Staff');

