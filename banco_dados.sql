-- Criação das tabelas
CREATE TABLE produtos (
    produto_id SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    preco numeric(10, 2)
);

CREATE TABLE vendas (
    venda_id SERIAL PRIMARY KEY,
    produto_id INT REFERENCES produtos(produto_id),
    quantidade INT,
    data_venda DATE
);

-- Inserção de dados de exemplo
INSERT INTO produtos (nome, preco) VALUES
    ('Produto A', 10.00),
    ('Produto B', 20.00),
    ('Produto C', 15.00);

INSERT INTO vendas (produto_id, quantidade, data_venda) VALUES
    (1, 5, '2024-05-01'),
    (2, 3, '2024-05-01'),
    (1, 2, '2024-05-02'),
    (3, 4, '2024-05-02'),
    (1, 7, '2024-05-03');

-- Criação da procedure para o relatório diário
CREATE OR REPLACE PROCEDURE relatorio_quantidade_diaria()
AS $$
BEGIN
    DROP TABLE IF EXISTS temp_relatorio_quantidade_diaria;
    CREATE TEMP TABLE temp_relatorio_quantidade_diaria (
        data_venda DATE,
        quantidade_total INT
    );

    INSERT INTO temp_relatorio_quantidade_diaria (data_venda, quantidade_total)
    SELECT data_venda, SUM(quantidade) AS quantidade_total
    FROM vendas
    GROUP BY data_venda
    ORDER BY data_venda;

    -- Exibindo os resultados utilizando PERFORM
    PERFORM * FROM temp_relatorio_quantidade_diaria;
END;
$$ LANGUAGE plpgsql;

CALL relatorio_quantidade_diaria();