--order_no          int             Not null        primary key       订单编号
--cust_id           char(5)         Not null,                         客户号
--sale_id           char(5)         Not null,                         业务员编号
--tot_amt           numeric(9,2)    Not null,                         订单金额
--order_date        datetime        Not null,                         订货日期
--ship_date         datetime        Not null,                         出货日期
--invoice_no        char(10)        Not null                          发票号码

CREATE TABLE IF NOT EXISTS sales (
	order_no          int             Not null        primary key,
	cust_id           char(5)         Not null,                
	sale_id           char(5)         Not null,                        
	tot_amt           numeric(9,2)    Not null,                        
	order_date        datetime        Not null,                     
	ship_date         datetime        Not null,                        
	invoice_no        char(10)        Not null                          
);