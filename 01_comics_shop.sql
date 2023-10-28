CREATE DATABASE ComicsShop;

GO

USE ComicsShop;

CREATE TABLE comics_categories (
	id BIGINT PRIMARY KEY IDENTITY,
	category_name VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE comics (
	comic_id BIGINT PRIMARY KEY IDENTITY,
	title VARCHAR(255) NOT NULL,
	description VARCHAR(255) DEFAULT 'NULL',
	unit_price DECIMAL(5,2)  NOT NULL,
	units_stock INT  NOT NULL,
	active BIT NOT NULL,
	category_id BIGINT FOREIGN KEY REFERENCES comics_categories(id)
);

CREATE TABLE authors (
	author_id BIGINT PRIMARY KEY IDENTITY,
	author_first_name VARCHAR(255)  NOT NULL,
	author_last_name VARCHAR(255) NOT NULL
);

CREATE TABLE comics_authors (
	comic_id BIGINT FOREIGN KEY REFERENCES comics(comic_id),
	author_id BIGINT FOREIGN KEY REFERENCES authors(author_id),
	PRIMARY KEY (comic_id, author_id)
);

CREATE TABLE addresses(
	address_id BIGINT PRIMARY KEY IDENTITY,
	country VARCHAR(255)  NOT NULL,
	state  VARCHAR(255)  NOT NULL,
	city VARCHAR(255) NOT NULL,
	street VARCHAR(255) NOT NULL,
	street_number SMALLINT NOT NULL,
	block_number SMALLINT NOT NULL,
	staircase_number SMALLINT NOT NULL,
	apartment_number SMALLINT NOT NULL,
	zip_code VARCHAR(10)  NOT NULL
);

CREATE TABLE customers(
	customer_id BIGINT PRIMARY KEY IDENTITY,
	first_name VARCHAR(255) NOT NULL,
	last_name VARCHAR(255)  NOT NULL,
	email VARCHAR(255)  NOT NULL,
	address_id BIGINT FOREIGN KEY REFERENCES addresses(address_id)
);

CREATE TABLE orders (
	order_id BIGINT PRIMARY KEY IDENTITY,
	order_tracking_number uniqueidentifier DEFAULT NEWSEQUENTIALID() NOT NULL,
	customer_id BIGINT FOREIGN KEY REFERENCES customers(customer_id),
	total_price DECIMAL(11,2),
	shipping_status VARCHAR(255) NOT NULL,
	date_created DATE NOT NULL,
	last_updated DATE NOT NULL
);

CREATE TABLE order_item(
	order_id BIGINT FOREIGN KEY REFERENCES orders(order_id),
	comic_id BIGINT FOREIGN KEY REFERENCES comics(comic_id), 
	comic_quantity INT  NOT NULL,
	sale_price DECIMAL(11,2) NOT NULL
	PRIMARY KEY (order_id, comic_id)
);
