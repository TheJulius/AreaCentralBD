DROP TABLE produtos;
DROP TABLE ultimas_vendas;
DROP PROCEDURE vendas;
DROP PROCEDURE atualiza_produto;
DROP PROCEDURE deleta_produto;

CREATE TABLE `area_central`.`produtos` (
  `id_produtos` INT NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(45) NOT NULL,
  `valor_unitario` DOUBLE NOT NULL,
  `estoque` INT NOT NULL,
  `data_ultima_venda` DATE NOT NULL,
  `total_de_vendas` DOUBLE NOT NULL,
  `codigo_de_barras` VARCHAR(13),
  `valor_ultima_venda` DOUBLE,
  PRIMARY KEY (`id_produtos`));
  
  CREATE TABLE `area_central`.`ultimas_vendas` (
  `id_ultimas_vendas` INT NOT NULL AUTO_INCREMENT,
  `produto` VARCHAR(45) NOT NULL,
  `quantidade` INT NOT NULL,
  `valor_unitario` DOUBLE NOT NULL,
  `valor_total_venda` DOUBLE NOT NULL,
  PRIMARY KEY (`id_ultimas_vendas`));
  
INSERT INTO `area_central`.`produtos`
(`id_produtos`,
`descricao`,
`valor_unitario`,
`estoque`,
`data_ultima_venda`,
`total_de_vendas`)
VALUES
(0,"batata", 1.50, 20000, "2020-01-01", 0),
(0,"coca", 7.50, 20000, "2020-01-01", 0),
(0,"arroz", 17.50, 2000, "2020-01-01", 0),
(0,"feijao", 5.50, 10000, "2020-01-01", 0);

DELIMITER $$
CREATE PROCEDURE vendas
(IN quantidade_vendido INT, IN valor_unitario DOUBLE, IN descricao VARCHAR(45))
BEGIN

UPDATE produtos AS p
SET p.estoque = p.estoque - quantidade_vendido,
	p.valor_unitario = valor_unitario,
    p.total_de_vendas = (valor_unitario * quantidade_vendido) + p.total_de_vendas,
    p.data_ultima_venda = CURDATE(),
    p.valor_ultima_venda = valor_unitario * quantidade_vendido
WHERE p.descricao = descricao;

INSERT INTO `area_central`.`ultimas_vendas`
(`id_ultimas_vendas`,
`produto`,
`quantidade`,
`valor_unitario`,
`valor_total_venda`)
VALUES
(0,descricao, quantidade_vendido, valor_unitario, quantidade_vendido*valor_unitario);

END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE atualiza_produto
(IN estoque INT, IN valor_unitario DOUBLE, IN codigo_de_barras VARCHAR(13), IN descricao VARCHAR(45))
BEGIN

UPDATE produtos AS p
SET p.estoque = estoque,
	p.valor_unitario = valor_unitario,
    p.codigo_de_barras = codigo_de_barras
WHERE p.descricao = descricao;

END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE deleta_produto
(IN descricao_produto VARCHAR(45))
BEGIN

DELETE
  FROM produtos 
WHERE descricao = descricao_produto;

END $$
DELIMITER ;



CALL vendas(20, 1.50, "batata");
CALL vendas(40, 1.50, "batata");
CALL atualiza_produto(100000, 23.68, 1234567891234, "arroz");
CALL deleta_produto("feijao");

SELECT * 
  FROM produtos;

SELECT * 
  FROM ultimas_vendas;