-- Tabela de clientes (compradores e vendedores)
CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    sex CHAR(1),
    address VARCHAR(255),
    birthday_date DATE,
    phone_number VARCHAR(30)
);

-- Tabela de categorias (com até 7 níveis hierárquicos)
CREATE TABLE Category (
    category_id INT PRIMARY KEY,
    categ_name_l1 VARCHAR(100),
    categ_name_l2 VARCHAR(100),
    categ_name_l3 VARCHAR(100),
    categ_name_l4 VARCHAR(100),
    categ_name_l5 VARCHAR(100),
    categ_name_l6 VARCHAR(100),
    categ_name_l7 VARCHAR(100)
);

-- Tabela de itens
CREATE TABLE Item (
    item_id INT PRIMARY KEY,
    seller_id INT NOT NULL,
    category_id INT NOT NULL,
    title_name_item VARCHAR(255),
    description TEXT,
    price DECIMAL(10,2),
    status VARCHAR(50),
    FOREIGN KEY (seller_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

-- Tabela de ordens de compra
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    item_id INT NOT NULL,
    buyer_id INT NOT NULL,
    seller_id INT NOT NULL,
    qtd_ord INT,
    unity_price DECIMAL(10,2),
    order_date DATE,
    FOREIGN KEY (item_id) REFERENCES Item(item_id),
    FOREIGN KEY (buyer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (seller_id) REFERENCES Customer(customer_id)
);
