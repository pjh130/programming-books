--order_no             int Not            null,            primary key          订单编号
--prod_id              char(5)            Not null,                             产品编号
--qty                  int                Not null                              销售数量
--unit_price           numeric(7,2)       Not null                              单价
--order_date           datetime null                                            订单日期

CREATE TABLE IF NOT EXISTS sale_item (
	order_no             int                Not null            primary key,
	prod_id              char(5)            Not null,                    
	qty                  int                Not null,                 
	unit_price           numeric(7,2)       Not null                       
);