SELECT 
 customerid,
 SUM(Sales) sumscore,
 rank() over(ORDER BY SUM(Sales)) [Rank sum]
from Sales.Orders
GROUP BY CustomerID

select *
from sales.Orders