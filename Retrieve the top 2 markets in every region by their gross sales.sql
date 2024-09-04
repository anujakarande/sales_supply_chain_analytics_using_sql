WITH cte1 AS (
    SELECT 
        s.fiscal_year, 
        c.market, 
        c.region, 
        SUM(s.sold_quantity * g.gross_price) AS net_sales  -- Aggregate net_sales at this level
    FROM fact_sales_monthly s 
    JOIN dim_customer c 
    ON c.customer_code = s.customer_code
    JOIN fact_gross_price g 
    ON g.fiscal_year = s.fiscal_year AND g.product_code = s.product_code
    WHERE s.fiscal_year = 2021   -- Filter fy
    GROUP BY s.fiscal_year, c.market, c.region  -- Group by fiscal_year, market, and region
),
cte2 AS(SELECT 
    market, 
    region, 
round(SUM(net_sales) OVER (PARTITION BY market,region) / 1000000,2) AS net_sales_mln  -- Partition by region for total sales
FROM cte1
GROUP BY market, region  -- Group by market and region in the outer query as well
ORDER BY net_sales_mln DESC),

cte3 AS (SELECT 
	*,
	DENSE_RANK() OVER(PARTITION BY region ORDER BY net_sales_mln desc) AS d_rank
    FROM cte2)
SELECT * FROM cte3
WHERE d_rank<=2;



with cte1 as (Select p.division,p.product,sum(sold_quantity) as total_qty 
from fact_sales_monthly s
join dim_product p 
on p.product_code=s.product_code
where fiscal_year=2021
),
 
cte2 as (select *, dense_rank() OVER(partition by division order by total_qty desc) as drnk
from cte1 )  


select * from cte2 
where drnk <=3 
    

