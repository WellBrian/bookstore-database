-- DATABASE CREATION
CREATE DATABASE bookstore;
USE bookstore;

-- CORE TABLES
-- Book language table
CREATE TABLE book_language (
    language_id INT PRIMARY KEY AUTO_INCREMENT,
    language_name VARCHAR(50) NOT NULL
);

-- Publisher table
CREATE TABLE publisher (
    publisher_id INT PRIMARY KEY AUTO_INCREMENT,
    publisher_name VARCHAR(150) NOT NULL,
    established_date DATE,
    website VARCHAR(255)
);

-- Author table
CREATE TABLE author (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    nationality VARCHAR(50)
);

-- Book table
CREATE TABLE book (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    language_id INT,
    publisher_id INT,
    num_pages INT,
    publication_year YEAR,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    FOREIGN KEY (language_id) REFERENCES book_language(language_id),
    FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id)
);

-- Book-Author (many-to-many relationship)
CREATE TABLE book_author (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id),
    FOREIGN KEY (author_id) REFERENCES author(author_id)
);

--CUSTOMER RELATED TABLES
-- Country table
CREATE TABLE country (
    country_id INT PRIMARY KEY AUTO_INCREMENT,
    country_name VARCHAR(100) NOT NULL,
    country_code VARCHAR(3) NOT NULL
);

-- Address status table
CREATE TABLE address_status (
    status_id INT PRIMARY KEY AUTO_INCREMENT,
    status_name VARCHAR(50) NOT NULL
);

-- Address table
CREATE TABLE address (
    address_id INT PRIMARY KEY AUTO_INCREMENT,
    street_number VARCHAR(10),
    street_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50)
    postal_code VARCHAR(20),
    country_id INT NOT NULL,
    FOREIGN KEY (country_id) REFERENCES country(country_id)
);

-- Customer table
CREATE TABLE customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    registration_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Customer address (many addresses per customer)
CREATE TABLE customer_address (
    customer_id INT,
    address_id INT,
    status_id INT,
    PRIMARY KEY (customer_id, address_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (address_id) REFERENCES address(address_id),
    FOREIGN KEY (status_id) REFERENCES address_status(status_id)
);

-- ORDER-RELATED TABLES
-- Shipping method
CREATE TABLE shipping_method (
    shipping_method_id INT PRIMARY KEY AUTO_INCREMENT,
    method_name VARCHAR(100),
    cost DECIMAL(10,2) NOT NULL,
    delivery_time_days INT
);

-- Order status
CREATE TABLE order_status (
    status_id INT PRIMARY KEY AUTO_INCREMENT,
    status_value VARCHAR(50)
);

-- Customer orders
CREATE TABLE cust_order (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATETIME DEAULT CURRENT_TIMESTAMP,
    shipping_address_id INT NOT NULL,
    shipping_method_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (shipping_address_id) REFERENCES address(address_id),
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(shipping_method_id)
);

-- Order lines (books per order)
CREATE TABLE order_line (
    order_line_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    book_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    price_each DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id)
);

-- Order history
CREATE TABLE order_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    status_id INT NOT NULL,
    status_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (status_id) REFERENCES order_status(status_id)
);


-- INSERT DATA INTO THE CREATED TABLES

-- book_language
INSERT INTO book_language (language_name) VALUES 
('English'), ('Swahili'), ('French'), ('Zulu'), ('Arabic');

-- publisher 
INSERT INTO publisher (publisher_name, established_date, website) VALUES 
('Longhorn Publishers', '1965-05-01', 'https://www.longhornpublishers.com'),
('Pearson Education', '1998-03-14', 'https://www.pearson.com'),
('Heinemann', '1970-09-20', 'https://www.heinemann.com'),
('Macmillan', '1950-01-01', 'https://www.macmillan.com'),
('Oxford University Press', '1900-01-01', 'https://www.oup.com');

-- author
INSERT INTO author (first_name, last_name, nationality) VALUES 
('Ngugi', 'Wa Thiongo', 'Kenyan'),
('Chimamanda', 'Adichie', 'Nigerian'),
('Wole', 'Soyinka', 'Nigerian'),
('Athol', 'Fugard', 'South African'),
('Nawal', 'El Saadawi', 'Egyptian');

-- book
INSERT INTO book (title, isbn, language_id, publisher_id, num_pages, publication_year, price, stock_quantity) VALUES 
('Petals of Blood', '9780000001', 1, 1, 432, 1977, 13.99, 20),
('Half of a Yellow Sun', '9780000002', 1, 2, 448, 2006, 15.99, 30),
('Ake: The Years of Childhood', '9780000003', 1, 3, 224, 1981, 11.50, 25),
('Master Harold and the Boys', '9780000004', 1, 4, 96, 1982, 10.00, 18),
('Woman at Point Zero', '9780000005', 3, 5, 160, 1975, 9.99, 15);

-- book_author
INSERT INTO book_author (book_id, author_id) VALUES 
(1, 1), 
(2, 2), 
(3, 3), 
(4, 4), 
(5, 5);

-- country
INSERT INTO country (country_name, country_code) VALUES 
('Kenya', 'KEN'),
('Nigeria', 'NGA'),
('South Africa', 'ZAF'),
('Egypt', 'EGY'),
('Tanzania', 'TZA');

-- address_status
INSERT INTO address_status (status_name) VALUES 
('Current'), 
('Previous'), 
('Billing'), 
('Shipping'), 
('Old');

-- address
INSERT INTO address (street_number, street_name, city, state, postal_code, country_id) VALUES 
('10', 'Moi Avenue', 'Nairobi', 'Nairobi', '00100', 1),
('5', 'Allen Avenue', 'Lagos', 'Lagos', '100001', 2),
('22', 'Long Street', 'Cape Town', 'Western Cape', '8001', 3),
('8', 'Tahrir Square', 'Cairo', 'Cairo', '11511', 4),
('3', 'Bagamoyo Rd', 'Dar es Salaam', 'Dar', '14111', 5);

-- customer
INSERT INTO customer (first_name, last_name, email, phone) VALUES 
('Brian', 'Ouko', 'brian@bookstore.com', '+254700000001'),
('Amina', 'Chukwu', 'amina@reader.ng', '+234800000002'),
('Sipho', 'Moyo', 'sipho@za.co', '+277300000003'),
('Leila', 'Ahmed', 'leila@cairo.egy', '+202000000004'),
('Juma', 'Mkapa', 'juma@tz.net', '+255600000005');

-- customer_address
INSERT INTO customer_address (customer_id, address_id, status_id) VALUES 
(1, 1, 1),
(2, 2, 1),
(3, 3, 1),
(4, 4, 1),
(5, 5, 1);

-- shipping_method
INSERT INTO shipping_method (method_name, cost, delivery_time_days) VALUES 
('Standard Shipping', 5.00, 5),
('Express Delivery', 10.00, 2),
('Same-Day Delivery', 15.00, 1),
('Pickup from Store', 0.00, 0),
('Weekend Delivery', 7.50, 3);

-- order_status
INSERT INTO order_status (status_value) VALUES 
('Pending'), 
('Shipped'), 
('Delivered'), 
('Cancelled'), 
('Processing');

-- cust_order
INSERT INTO cust_order (customer_id, order_date, shipping_address_id, shipping_method_id) VALUES 
(1, NOW(), 1, 1),
(2, NOW(), 2, 2),
(3, NOW(), 3, 3),
(4, NOW(), 4, 4),
(5, NOW(), 5, 5);

-- order_line
INSERT INTO order_line (order_id, book_id, quantity, price_each) VALUES 
(1, 1, 1, 13.99),
(2, 2, 2, 15.99),
(3, 3, 1, 11.50),
(4, 4, 3, 10.00),
(5, 5, 1, 9.99);

-- order_history
INSERT INTO order_history (order_id, status_id) VALUES 
(1, 1), 
(2, 2), 
(3, 3), 
(4, 4), 
(5, 5);
