/*USING salesDB */
/* find AVG  sales across all orders and additionally  orderID and Order Date*/
SELECT
   OrderID,
   OrderDate,
   Sales,
   productID,
   Avg(Sales) over() as avgsales,
    /* AVG for each product*/
   Avg(Sales) over(PARTITION BY ProductID) as avgsalesgroup
from Sales.Orders



/* find avrage score of customers add*/
SELECT 
CustomerID,
Country,
score,
AVG(Score) over() [avg score],
--handelinfg NULLs
COALESCE(score,0) [coal score],
AVG(COALESCE(score,0)) over() [avg-coal score]
from Sales.Customers


--find all orders whre sales are higher than 
--the average sales across all orders

select *
from  ( select
         OrderID,
         ProductID,
         Sales,
         COALESCE(Sales,0) coalsales,
         AVG(COALESCE(Sales,0)) over() as avg_sales
                  FROM Sales.Orders
     )t
     WHERE Sales > avg_sales

/* find max - min sales across all order */

SELECT OrderID,
ProductID,
OrderDate,
Sales,
MAX( COALESCE(Sales,0)) over () max_sales,
MIN( COALESCE(Sales,0)) over () min_sales
 from Sales.Orders

 /*find max - min sales for each order
additionally provide detaies  such as orderID and OrderDate*/
SELECT OrderID,
ProductID,
OrderDate,
Sales,
MAX( COALESCE(Sales,0)) over (PARTITION BY productID) max_sales_group,
MIN( COALESCE(Sales,0)) over (PARTITION BY productID) min_sales_group,

-- deviatio of each sale from both min& max sales amounts
Sales - MIN( COALESCE(Sales,0)) over() deviationfromMIN,
ABS(Sales - MAX( COALESCE(Sales,0)) over()) deviationfromMAX
 from Sales.Orders


 /* show the employees with the highest salarie*/
  SELECT EmployeeID,
      LastName,
      Salary,
      max(Salary) over() highest_salery
  
  from  Sales.Employees
  /* show just details about maximum row 
  note :  we cannot window function  use in WHERE  directly*/
  select * 
  from 
  (
 SELECT *,
      max(Salary) over() highest_salery
  
  from  Sales.Employees

  )t 
 WHERE Salary = highest_salery
GO
 /* moving ANG  of sales for each product over time */
select 
OrderDate,
ProductID,
    Sales,
--for each product
   AVG(Sales) over (PARTITION BY productID) avg_each_product,
 --RUNING TOTAL over time
  AVG(Sales) over (PARTITION BY productID ORDER BY OrderDate) Moving_AVG,

 --moving AVG  of sales for each product over time
 -- including only the next order. 
 --Rolling total
 AVG(Sales) over (PARTITION BY productID ORDER BY OrderDate ROWS BETWEEN CURRENT ROW and 1 following) Rolling_avg
  from Sales.Orders