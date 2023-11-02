-- Create the country table
CREATE TABLE country (
    country_id INT PRIMARY KEY,
    country VARCHAR(50) NOT NULL
);

-- Create the city table
CREATE TABLE city (
    city_id INT PRIMARY KEY,
    city VARCHAR(50) NOT NULL,
    country_id INT,
    FOREIGN KEY (country_id) REFERENCES country(country_id)
);

-- Create the address table
CREATE TABLE address (
    address_id INT PRIMARY KEY,
    address VARCHAR(50) NOT NULL,
    address2 VARCHAR(50),
    district VARCHAR(20) NOT NULL,
    city_id INT,
    postal_code VARCHAR(10) NOT NULL,
    phone VARCHAR(20),
    FOREIGN KEY (city_id) REFERENCES city(city_id)
);

-- Create the language table
CREATE TABLE language (
    language_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

-- Create the category table
CREATE TABLE category (
    category_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

-- Create the actor table
CREATE TABLE actor (
    actor_id INT PRIMARY KEY,
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL
);

-- Create the store table
CREATE TABLE store (
    store_id INT PRIMARY KEY,
    address_id INT,
    FOREIGN KEY (address_id) REFERENCES address(address_id)
);

-- Create the customer table
CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    store_id INT,
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    email VARCHAR(50),
    address_id INT,
    active TINYINT NOT NULL CHECK (active IN (0, 1)),
    FOREIGN KEY (store_id) REFERENCES store(store_id),
    FOREIGN KEY (address_id) REFERENCES address(address_id)
);

-- Create the staff table
CREATE TABLE staff (
    staff_id INT PRIMARY KEY,
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    address_id INT,
    email VARCHAR(50),
    store_id INT,
    active TINYINT NOT NULL CHECK (active IN (0, 1)),
    username VARCHAR(20) NOT NULL,
    password VARCHAR(20) NOT NULL,
    FOREIGN KEY (address_id) REFERENCES address(address_id),
    FOREIGN KEY (store_id) REFERENCES store(store_id)
);

-- Create the film table
CREATE TABLE film (
    film_id INT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    release_year YEAR,
    language_id INT,
    rental_duration INT NOT NULL CHECK (rental_duration BETWEEN 2 AND 8),
    rental_rate DECIMAL(4, 2) NOT NULL CHECK (rental_rate BETWEEN 0.99 AND 6.99),
    length INT NOT NULL CHECK (length BETWEEN 30 AND 200),
    replacement_cost DECIMAL(5, 2) NOT NULL CHECK (replacement_cost BETWEEN 5.00 AND 100.00),
    rating ENUM('PG', 'G', 'NC-17', 'PG-13', 'R'),
    special_features SET('Behind the Scenes', 'Commentaries', 'Deleted Scenes', 'Trailers'),
    FOREIGN KEY (language_id) REFERENCES language(language_id)
);

-- Create the film_actor table
CREATE TABLE film_actor (
    actor_id INT,
    film_id INT,
    PRIMARY KEY (actor_id, film_id),
    FOREIGN KEY (actor_id) REFERENCES actor(actor_id),
    FOREIGN KEY (film_id) REFERENCES film(film_id)
);

-- Create the film_category table
CREATE TABLE film_category (
    film_id INT,
    category_id INT,
    PRIMARY KEY (film_id, category_id),
    FOREIGN KEY (film_id) REFERENCES film(film_id),
    FOREIGN KEY (category_id) REFERENCES category(category_id)
);

-- Create the inventory table
CREATE TABLE inventory (
    inventory_id INT PRIMARY KEY,
    film_id INT,
    store_id INT,
    FOREIGN KEY (film_id) REFERENCES film(film_id),
    FOREIGN KEY (store_id) REFERENCES store(store_id)
);

-- Create the rental table
CREATE TABLE rental (
    rental_id INT PRIMARY KEY,
    rental_date DATETIME NOT NULL,
    inventory_id INT,
    customer_id INT,
    return_date DATETIME,
    staff_id INT,
    FOREIGN KEY (inventory_id) REFERENCES inventory(inventory_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

-- Create the payment table
CREATE TABLE payment (
    payment_id INT PRIMARY KEY,
    customer_id INT,
    staff_id INT,
    rental_id INT,
    amount DECIMAL(5, 2) NOT NULL CHECK (amount >= 0),
    payment_date DATETIME NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id),
    FOREIGN KEY (rental_id) REFERENCES rental(rental_id)
);
