--emp_no            char(5)         Not null           primary key        员工编号
--emp_name          char(10)        Not null                              员工姓名
--sex               char(1)         Not null                              性别
--dept              char(4)         Not null                              所属部门
--title             char(6)         Not null                              职称
--date_hired        datetime        Not null                              到职日
--birthday          datetime        Null                                  生日
--salary            int             Not null                              薪水
--addr              char(50)        null                                  住址
--Mod­_date         datetime        Default(getdate())                    操作者

CREATE TABLE IF NOT EXISTS employee (
	emp_no            char(5)         Not null           primary key,
	emp_name          char(10)        Not null,                             
	sex               char(1)         Not null,                            
	dept              char(4)         Not null,                          
	title             char(6)         Not null,                          
	date_hired        datetime        Not null,                            
	birthday          datetime        null,                              
	salary            int             Not null,                             
	addr              char(50)        null,                                 
	Mod­_date         datetime        Default(getdate())                   
);