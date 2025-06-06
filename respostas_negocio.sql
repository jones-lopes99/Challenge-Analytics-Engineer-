-- 1. Listar os usuários que cumprem anos hoje e venderam mais de 1500 vezes em janeiro de 2020
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(o.order_id) AS total_vendas_jan_2020
FROM Customer c
JOIN Orders o ON o.seller_id = c.customer_id
WHERE
    EXTRACT(MONTH FROM c.birthday_date) = EXTRACT(MONTH FROM CURRENT_DATE)
    AND EXTRACT(DAY FROM c.birthday_date) = EXTRACT(DAY FROM CURRENT_DATE)
    AND o.order_date BETWEEN '2020-01-01' AND '2020-01-31'
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(o.order_id) > 1500;

-- 2. Top 5 usuários por mês de 2020 que mais venderam em valor na categoria "Celulares"
WITH categoria_celulares AS (
    SELECT categ_name_l1,
    categ_name_l2 , 
    categ_name_l3 
    FROM Category
    WHERE
        category_id = 25674 -- id da categoria de celulares
),
vendas_2020 AS (
    SELECT
        o.seller_id,
        categ_name_l1,
        categ_name_l2 , 
        categ_name_l3,
        EXTRACT(YEAR FROM o.order_date) AS ano,
        EXTRACT(MONTH FROM o.order_date) AS mes,
        COUNT(DISTINCT o.order_id) AS qtd_vendas,
        SUM(o.qtd_ord) AS qtd_itens,
        SUM(o.qtd_ord * o.unity_price) AS valor_vendido
    FROM Orders o
    JOIN Item i ON o.item_id = i.item_id
    WHERE
        i.category_id IN (SELECT category_id FROM categoria_celulares)
        AND o.order_date BETWEEN '2020-01-01' AND '2020-12-31'
    GROUP BY  o.seller_id,categ_name_l1,categ_name_l2 ,categ_name_l3
),
ranked_vendedores AS (
    SELECT
        v.*,
        c.first_name,
        c.last_name,
        RANK() OVER (PARTITION BY v.ano, v.mes ORDER BY v.valor_vendido DESC) AS posicao
    FROM vendas_2020 v
    JOIN Customer c ON c.customer_id = v.seller_id
)
SELECT
    ano,
    mes,
    seller_id,
    first_name,
    last_name,
    qtd_vendas,
    qtd_itens,
    valor_vendido
FROM ranked_vendedores
WHERE posicao <= 5
ORDER BY ano, mes, posicao;

-- 3. Tabela com o preço e status atual dos itens no final do dia

CREATE TABLE IF NOT EXISTS Item_Daily_Snapshot (
    snapshot_date DATE,
    item_id INT,
    price DECIMAL(10,2),
    status VARCHAR(50),
    PRIMARY KEY (snapshot_date, item_id)
);

-- Exemplo de código para um processamento diário reprocessável (substitui se já existir)

DELETE FROM Item_Daily_Snapshot
WHERE snapshot_date = CURRENT_DATE;

INSERT INTO Item_Daily_Snapshot (snapshot_date, item_id, price, status)
SELECT
    CURRENT_DATE AS snapshot_date,
    item_id,
    price,
    status
FROM Item;
