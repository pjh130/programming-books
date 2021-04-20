--cust_id       char(5)      Not null      primary key    客户号
--cust_name     char(20)     Not null,                    客户名称
--addr          char(40)     Not null,                    客户住址
--tel_no        char(10)     Not null,                    客户电话
--zip           char(6)      null                         邮政编码

CREATE TABLE IF NOT EXISTS customer (
	cust_id       char(5)      Not null      primary key,    
	cust_name     char(20)     Not null,                    
	addr          char(40)     Not null,                    
	tel_no        char(10)     Not null,                   
	zip           char(6)      null                         
);