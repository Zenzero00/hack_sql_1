-- Hack 5
CREATE TABLE countries(
  id_country serial PRIMARY KEY,
  NAME VARCHAR(50) not NULL
);

CREATE TABLE roles(
  id_role serial PRIMARY KEY,
  NAME VARCHAR(50) not NULL
);

CREATE TABLE taxes(
  id_tax serial PRIMARY KEY,
  percentage NUMERIC(5,2) NOT NULL
);

CREATE TABLE offers(
  id_offer serial PRIMARY KEY,
  status VARCHAR(50) CHECK(status IN ('Activa', 'Inactiva')) NOT NULL
);

CREATE TABLE discounts(
  id_discount serial PRIMARY KEY,
  status VARCHAR(50) CHECK(status IN ('Activa', 'Inactiva')) NOT NULL,
  percentage NUMERIC(5,2) NOT NULL
);

CREATE TABLE payments(
  id_payment serial PRIMARY KEY,
  TYPE VARCHAR(50) NOT NULL
);

CREATE TABLE customers(
  id_customer serial PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  id_country INT UNIQUE REFERENCES countries(id_country),
  id_role INT UNIQUE REFERENCES roles(id_role),
  name VARCHAR(100) not NULL,
  age INT not NULL,
  PASSWORD VARCHAR(255) not NULL,
  physical_address VARCHAR(255) not NULL
);

CREATE TABLE invoice_status(
  id_invoice_status serial PRIMARY KEY,
  status VARCHAR(50) NOT NULL
);

CREATE TABLE products(
  id_product serial PRIMARY KEY,
  id_discount INT UNIQUE REFERENCES discounts(id_discount),
  id_offer INT UNIQUE REFERENCES offers(id_offer),
  id_tax INT UNIQUE REFERENCES taxes(id_tax),
  name VARCHAR(100) not NULL,
  DETAIL VARCHAR(255),
  minimum_stock INT not NULL,
  maximun_stock INT NOT NULL,
  current_stock INT not NULL,
  price NUMERIC(10,2) not NULL,
  price_with_tax NUMERIC(10,2) not NULL
);

create table products_customers (
    id_customer integer,
    id_product integer,
    foreign key (id_customer) references customers (id_customer),
    foreign key (id_product) references products (id_product),
    PRIMARY KEY (id_customer, id_product)
);

create table invoices (
  id_invoice SERIAL PRIMARY KEY,
  id_customer INT UNIQUE REFERENCES customers(id_customer) ON DELETE CASCADE,
  id_payment INT UNIQUE REFERENCES payments(id_payment),
  id_invoice_status INT UNIQUE REFERENCES invoice_status(id_invoice_status),
  date DATE not NULL,
  total_to_pay NUMERIC(10,2) not NULL
);

create table orders(
  id_order SERIAL PRIMARY KEY,
  id_invoice INT UNIQUE REFERENCES invoices(id_invoice) ON DELETE CASCADE,
  id_product INT UNIQUE REFERENCES products(id_product),
  id_invoice_status INT UNIQUE REFERENCES invoice_status(id_invoice_status),
  detail VARCHAR(255),
  amount INT not NULL,
  price NUMERIC(10,2) not NULL
);

-- Hack 6
-- Insert
INSERT INTO countries (name) VALUES ('Venezuela'), ('Colombia'), ('Perú');
INSERT INTO roles (name) VALUES ('Programador'), ('Diseñador Gráfico'), ('Atención al cliente');
INSERT into taxes (percentage) VALUES (0.04), (0.04), (0.04);
INSERT into offers (status) VALUES ('Activa'), ('Inactiva'), ('Activa');
INSERT into discounts (status, percentage) VALUES ('Activa', 0.4), ('Inactiva', 0.9), ('Activa', 0.6);
INSERT INTO payments (type) VALUES ('Pago Movil'), ('Tarjeta de Credito'), ('Paypal');
INSERT INTO customers (id_country, id_role, email, name, age, password, physical_address) 
VALUES (1,1,'correo1@gmail.com', 'Francisco', 22, '1234', 'Calle1'),
(2,2,'correo2@gmail.com', 'Oswaldo', 54, '5678', 'Calle2'), 
(3,3,'correo3@gmail.com', 'Laura', 35, 'abcd', 'Calle3');
INSERT into invoice_status (status) VALUES ('Pagado'), ('Pendiente'), ('Anulado');
INSERT into products (id_discount, id_offer, id_tax, name, detail, minimum_stock, maximun_stock, current_stock, price, price_with_tax)
VALUES (1,1,1,'Manzana', 'Comida', 1, 30, 10, 4.5, 4.68),
(2,2,2,'Collar', 'Accesorio', 1, 15, 5, 7.2, 7.49),
(3,3,3,'Camisa', 'Ropa', 1, 20, 8, 6.2, 6.49);
INSERT into invoices (id_customer, id_payment, id_invoice_status, date, total_to_pay)
VALUES (1,1,1, '2024-05-28', 14.04), (2,2,2, '2024-04-22', 7.49), (3,3,3, '2024-05-28', 12.98);
INSERT into orders (id_invoice, id_product, id_invoice_status, detail, amount, price)
VALUES (1, 1, 1, 'Manzanas', 3, 13.5), (2, 2, 2, 'Collar', 1, 7.2), (3, 3, 3, 'Camisas', 2, 12.4);

-- Delete
DELETE FROM customers WHERE id_customer = (SELECT MIN(id_customer) FROM customers);

-- Update
UPDATE customers SET (email, id_country, id_role, name, age, password, physical_address) = 
('correo4@gmail.com', 1,1, 'Pedro', 28, 'ab12', 'Calle4')
WHERE id_customer = (SELECT MAX(id_customer) FROM customers);
UPDATE taxes set percentage = 0.1 WHERE id_tax in (1,2,3);
UPDATE products SET (price, price_with_tax) = (5, 5.5) WHERE id_product = 1;
UPDATE products SET (price, price_with_tax) = (8, 8.8) WHERE id_product = 2; 
UPDATE products SET (price, price_with_tax) = (6.9, 7.59) WHERE id_product = 3;
