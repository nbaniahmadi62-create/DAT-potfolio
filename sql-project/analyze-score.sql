SELECT MAX(Score) as maximum,
        MIN(Score) as minimum,
        SUM(Score)as summerize,
        AVG(score) as averaage,
        count(score)

from sales.Customers
GROUP BY Country