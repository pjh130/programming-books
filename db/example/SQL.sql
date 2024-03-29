--查找员工的编号、姓名、部门和出生日期，如果出生日期为空值，显示日期不详
select emp_no ,emp_name ,dept ,
       isnull(convert(char(10),birthday,120),'日期不详') birthday
from employee
order by dept;

--按部门进行汇总，统计每个部门的总工资
select dept,sum(salary)
from employee
group by dept;

--查找商品名称为14寸显示器商品的销售情况，显示该商品的编号、销售数量、单价和金额
select a.prod_id,qty,unit_price,unit_price*qty totprice
from sale_item a,product b
where a.prod_id=b.prod_id and prod_name='14寸显示器';

--在销售明细表中按产品编号进行汇总，统计每种产品的销售数量和金额
select prod_id,sum(qty) totqty,sum(qty*unit_price) totprice
from sale_item
group by prod_id;

--使用convert函数按客户编号统计每个客户1996年的订单总金额
select cust_id,sum(tot_amt) totprice
from sales
where convert(char(4),order_date,120)='1996'
group by cust_id;

--查找有销售记录的客户编号、名称和订单总额
select a.cust_id,cust_name,sum(tot_amt) totprice
from customer a,sales b
where a.cust_id=b.cust_id
group by a.cust_id,cust_name;

--查找在1997年中有销售记录的客户编号、名称和订单总额
select a.cust_id,cust_name,sum(tot_amt) totprice
from customer a,sales b
where a.cust_id=b.cust_id and convert(char(4),order_date,120)='1997'
group by a.cust_id,cust_name;

--查找一次销售最大的销售记录
select order_no,cust_id,sale_id,tot_amt
from sales
where tot_amt=
   (select max(tot_amt)
    from sales);
	
--查找至少有3次销售的业务员名单和销售日期
select emp_name,order_date
from employee a,sales b 
where emp_no=sale_id and a.emp_no in
  (select sale_id
   from sales
   group by sale_id
   having count(*)>=3)
order by emp_name;

--用存在量词查找没有订货记录的客户名称
select cust_name
from customer a
where not exists
   (select *
    from sales b
    where a.cust_id=b.cust_id);

--使用左外连接查找每个客户的客户编号、名称、订货日期、订单金额；订货日期不要显示时间，日期格式为yyyy-mm-dd；按客户编号排序，同一客户再按订单降序排序输出
select a.cust_id,cust_name,convert(char(10),order_date,120),tot_amt
from customer a left outer join sales b on a.cust_id=b.cust_id
order by a.cust_id,tot_amt desc;

--查找16M DRAM的销售情况，要求显示相应的销售员的姓名、性别，销售日期、销售数量和金额，其中性别用男、女表示
select emp_name 姓名, 性别= case a.sex  when 'm' then '男'
                                       when 'f' then '女' 
                                       else '未'
                                       end,
        销售日期= isnull(convert(char(10),c.order_date,120),'日期不详'),
        qty 数量, qty*unit_price as 金额
from employee a, sales b, sale_item c,product d
where d.prod_name='16M DRAM' and d.pro_id=c.prod_id and
      a.emp_no=b.sale_id and b.order_no=c.order_no;
	  
--查找每个人的销售记录，要求显示销售员的编号、姓名、性别、产品名称、数量、单价、金额和销售日期
select emp_no 编号,emp_name 姓名, 性别= case a.sex when 'm' then '男'
                                       when 'f' then '女' 
                                       else '未'
                                       end,
      prod_name 产品名称,销售日期= isnull(convert(char(10),c.order_date,120),'日期不详'),
      qty 数量, qty*unit_price as 金额
from employee a left outer join sales b on a.emp_no=b.sale_id , sale_item c,product d
where d.pro_id=c.prod_id and b.order_no=c.order_no;

--查找销售金额最大的客户名称和总货款
select cust_name,d.cust_sum
from   customer a,
       (select cust_id,cust_sum
        from (select cust_id, sum(tot_amt) as cust_sum
              from sales
              group by cust_id ) b
        where b.cust_sum = 
               ( select max(cust_sum)
                 from (select cust_id, sum(tot_amt) as cust_sum
                       from sales
                       group by cust_id ) c )
        ) d
where a.cust_id=d.cust_id;

--查找销售总额少于1000元的销售员编号、姓名和销售额
select emp_no,emp_name,d.sale_sum
from   employee a,
       (select sale_id,sale_sum
        from (select sale_id, sum(tot_amt) as sale_sum
              from sales
              group by sale_id ) b
        where b.sale_sum <1000               
        ) d
where a.emp_no=d.sale_id;

--查找至少销售了3种商品的客户编号、客户名称、商品编号、商品名称、数量和金额
select a.cust_id,cust_name,b.prod_id,prod_name,d.qty,d.qty*d.unit_price
from customer a, product b, sales c, sale_item d
where a.cust_id=c.cust_id and d.prod_id=b.prod_id and 
      c.order_no=d.order_no and a.cust_id in (
      select cust_id
      from  (select cust_id,count(distinct prod_id) prodid
             from (select cust_id,prod_id
                   from sales e,sale_item f
                   where e.order_no=f.order_no) g
             group by cust_id
             having count(distinct prod_id)>=3) h );
			 
--查找至少与世界技术开发公司销售相同的客户编号、名称和商品编号、商品名称、数量和金额
select a.cust_id,cust_name,d.prod_id,prod_name,qty,qty*unit_price
from customer a, product b, sales c, sale_item d
where a.cust_id=c.cust_id and d.prod_id=b.prod_id and 
      c.order_no=d.order_no  and not exists
  (select f.*
   from customer x ,sales e, sale_item f
   where cust_name='世界技术开发公司' and x.cust_id=e.cust_id and
         e.order_no=f.order_no and not exists
           ( select g.*
             from sale_item g, sales  h
             where g.prod_id = f.prod_id and g.order_no=h.order_no and
                   h.cust_id=a.cust_id);
    )
	
--查找表中所有姓刘的职工的工号，部门，薪水
select emp_no,emp_name,dept,salary
from employee
where emp_name like '刘%';

--查找所有定单金额高于20000的所有客户编号
select cust_id
from sales
where tot_amt>20000;

--统计表中员工的薪水在40000-60000之间的人数
select count(*)as 人数
from employee
where salary between 40000 and 60000;

--查询表中的同一部门的职工的平均工资，但只查询＂住址＂是＂上海市＂的员工
select avg(salary) avg_sal,dept 
from employee 
where addr like '上海市%'
group by dept;

--将表中住址为"上海市"的员工住址改为"北京市"
update employee  
set addr like '北京市'
where addr like '上海市';

--查找业务部或会计部的女员工的基本信息
select emp_no,emp_name,dept
from employee 
where sex='F'and dept in ('业务','会计');

--显示每种产品的销售金额总和，并依销售金额由大到小输出
select prod_id ,sum(qty*unit_price)
from sale_item 
group by prod_id
order by sum(qty*unit_price) desc;

--选取编号界于‘C0001’和‘C0004’的客户编号、客户名称、客户地址
select CUST_ID,cust_name,addr
from customer 
where cust_id between 'C0001' AND 'C0004';

--计算出一共销售了几种产品
select count(distinct prod_id) as '共销售产品数'
from sale_item;

--将业务部员工的薪水上调3%
update employee
set salary=salary*1.03
where dept='业务';

--由employee表中查找出薪水最低的员工信息
select *
from employee
where salary=
       (select min(salary )
        from employee );
		
--使用join查询客户姓名为"客户丙"所购货物的"客户名称","定单金额","定货日期","电话号码"
select a.cust_id,b.tot_amt,b.order_date,a.tel_no
from customer a join sales b
on a.cust_id=b.cust_id and cust_name like '客户丙';

--由sales表中查找出订单金额大于“E0013业务员在1996/10/15这天所接每一张订单的金额”的所有订单
select *
from sales
where tot_amt>all
       (select tot_amt 
        from sales 
        where sale_id='E0013'and order_date='1996/10/15')
order by tot_amt;

--计算'P0001'产品的平均销售单价
select avg(unit_price)
from sale_item
where prod_id='P0001';

--找出公司女员工所接的定单
select sale_id,tot_amt
from sales
where sale_id in 
(select sale_id from employee
where sex='F');

--找出同一天进入公司服务的员工
select a.emp_no,a.emp_name,a.date_hired
from employee a
join employee b
on (a.emp_no!=b.emp_no and a.date_hired=b.date_hired)
order by a.date_hired;

--找出目前业绩超过232000元的员工编号和姓名
select emp_no,emp_name
from employee 
where emp_no in
(select sale_id
from sales 
group by sale_id
having sum(tot_amt)<232000);

--查询出employee表中所有女职工的平均工资和住址在＂上海市＂的所有女职工的平均工资
select avg(salary)
from employee
where sex like 'f'
union
select avg(salary)
from employee
where sex like 'f' and addr like '上海市%';

--在employee表中查询薪水超过员工平均薪水的员工信息
Select * from employee where salary>(select avg(salary)  from employee);

--找出目前销售业绩超过40000元的业务员编号及销售业绩，并按销售业绩从大到小排序
Select sale_id ,sum(tot_amt)
from sales 
group by sale_id 
having sum(tot_amt)>40000
order by sum(tot_amt) desc;

--找出公司男业务员所接且订单金额超过2000元的订单号及订单金额
Select order_no,tot_amt
From sales ,employee
Where sale_id=emp_no and sex='M' and tot_amt>2000;

--查询sales表中订单金额最高的订单号及订单金额
Select order_no,tot_amt from sales where tot_amt=(select max(tot_amt)  from sales);

--查询在每张订单中订购金额超过24000元的客户名及其地址
Select cust_name,addr from customer a,sales b where a.cust_id=b.cust_id and tot_amt>24000;

--求出每位客户的总订购金额，显示出客户号及总订购金额，并按总订购金额降序排列
Select cust_id,sum(tot_amt) from sales
Group by cust_id 
Order by sum(tot_amt) desc;

--求每位客户订购的每种产品的总数量及平均单价，并按客户号，产品号从小到大排列
Select cust_id,prod_id,sum(qty),sum(qty*unit_price)/sum(qty)
From sales a, sale_item b
Where a.order_no=b.order_no
Group by cust_id,prod_id
Order by cust_id,prod_id;

--查询订购了三种以上产品的订单号
Select order_no from sale_item
Group by order_no
Having count(*)>3;

--查询订购的产品至少包含了订单10003中所订购产品的订单
Select  distinct order_no
From sale_item a
Where  order_no<>'10003'and  not exists ( 
       Select *  from sale_item b where order_no ='10003'  and not exists 
              (select *  from sale_item c where c.order_no=a.order_no  and  c.prod_id=b.prod_id));
			  
--在sales表中查找出订单金额大于“E0013业务员在1996/11/10这天所接每一张订单的金额”的所有订单，并显示承接这些订单的业务员和该订单的金额
Select sale_id,tot_amt 
from sales
where tot_amt>all(select tot_amt from sales where sale_id='E0013' and order_date='1996/11/10');

--查询末承接业务的员工的信息
Select *
From employee a
Where not exists 
         (select * from  sales b where  a.emp_no=b.sale_id);
		 
--查询来自上海市的客户的姓名，电话、订单号及订单金额
Select cust_name,tel_no,order_no,tot_amt
From customer a ,sales b
Where a.cust_id=b.cust_id and addr='上海市';

--查询每位业务员各个月的业绩，并按业务员编号、月份降序排序
Select sale_id,month(order_date), sum(tot_amt) 
from sales 
group by sale_id,month(order_date)
order by sale_id,month(order_date) desc;

--求每种产品的总销售数量及总销售金额，要求显示出产品编号、产品名称，总数量及总金额，并按产品号从小到大排列
Select a.prod_id,prod_name,sum(qty),sum(qty*unit_price)
From sale_item a,product b
Where a.prod_id=b.prod_id 
Group by a.prod_id,prod_name
Order by a.prod_id;

--查询总订购金额超过’C0002’客户的总订购金额的客户号，客户名及其住址
Select cust_id, cust_name,addr
From customer
Where cust_id  in (select cust_id from sales 
Group by cust_id
Having sum(tot_amt)>
        (Select sum(tot_amt) from sales  where cust_id='C0002'));
		
--查询业绩最好的的业务员号、业务员名及其总销售金额
select emp_no,emp_name,sum(tot_amt)
from employee a,sales b
where a.emp_no=b.sale_id
group by emp_no,emp_name
having sum(tot_amt)=
         (select max(totamt)
          from (select sale_id,sum(tot_amt) totamt
               from sales
               group by sale_id) c);
			   
--查询每位客户所订购的每种产品的详细清单，要求显示出客户号，客户名，产品号，产品名，数量及单价
select a.cust_id, cust_name,c.prod_id,prod_name,qty, unit_price
from customer a,sales b, sale_item c ,product d
where a.cust_id=b.cust_id and b.order_no=c.order_no and c.prod_id=d.prod_id;

--求各部门的平均薪水，要求按平均薪水从小到大排序
select dept,avg(salary) from employee group by dept order by avg(salary);
