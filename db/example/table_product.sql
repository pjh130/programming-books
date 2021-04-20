--prod_id          char(5)      Not null       primary key         产品编号
--prod_name        char(20)     Not null                           产品名称

CREATE TABLE IF NOT EXISTS product (
	prod_id          char(5)      Not null       primary key,
	prod_name        char(20)     Not null
);