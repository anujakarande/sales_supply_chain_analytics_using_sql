SELECT * FROM dim_customer
WHERE customer LIKE "%croma%" AND market="india";

SELECT * FROM gdb0041.fact_sales_monthly
WHERE customer_code = 90002002 and 
get_fiscal_year(date)= 2021 
ORDER BY DATE; 


SELECT * FROM gdb0041.fact_sales_monthly
WHERE customer_code = 90002002 AND
get_fiscal_year(date)= 2021 AND
get_quarter_fy(date) = "Q4"
ORDER BY DATE;


SELECT m_s.date,round((SUM(sold_quantity*g_p.gross_price)),2) AS monthly_sale FROM fact_sales_monthly AS m_s
JOIN fact_gross_price AS g_p 
ON g_p.product_code=m_s.product_code AND
g_p.fiscal_year=get_fiscal_year(m_s.date)
WHERE customer_code=90002002
GROUP BY m_s.date
ORDER BY m_s.date;


SELECT g_p.fiscal_year, 
SUM(round(m_s.sold_quantity*g_p.gross_price,2)) AS gross_sale FROM fact_sales_monthly as m_s
JOIN fact_gross_price AS g_p ON
g_p.product_code=m_s.product_code AND
g_p.fiscal_year=get_fiscal_year(m_s.date)
WHERE customer_code=90002002
GROUP BY fiscal_year
ORDER BY fiscal_year;

-- market badge
select c.market, sum(m_s.sold_quantity) as total_sold_qty from fact_sales_monthly as m_s
join dim_customer as c
on c.customer_code=m_s.customer_code   
where market="india" and get_fiscal_year(m_s.date)=2021
group by market;


#pre-invoice deduction
WITH pre_invoice AS (SELECT 
m_s.date, 
p.product_code, 
p.product, 
m_s.customer_code,
c.market,
p.variant, 
m_s.sold_quantity, 
g_p.gross_price, 
pre.pre_invoice_discount_pct
FROM fact_sales_monthly AS m_s
JOIN dim_product AS p
ON m_s.product_code = p.product_code
JOIN dim_customer c 
ON m_s.customer_code = c.customer_code
JOIN fact_gross_price AS g_p
ON 
	m_s.product_code = g_p.product_code AND
    m_s.fiscal_year = g_p.fiscal_year
JOIN fact_pre_invoice_deductions pre
ON
	m_s.customer_code = pre.customer_code AND
    m_s.fiscal_year = pre.fiscal_year
)
SELECT *, round((gross_price*sold_quantity-pre_invoice_discount_pct),2) AS net_invoice_sale FROM pre_invoice;

-- gross_sale
SELECT s.date, 
s.product_code, 
p.product, 
p.variant, 
s.sold_quantity, 
g.gross_price, 
ROUND(g.gross_price * s.sold_quantity, 2) AS gross_sale 
FROM fact_sales_monthly s 
JOIN dim_product p 
ON p.product_code = s.product_code 
JOIN fact_gross_price g 
ON g.product_code = s.product_code AND g.fiscal_year = get_fiscal_year(s.date) 
WHERE customer_code = 90002002 AND get_fiscal_year(s.date) = 2021 ORDER BY s.date ASC LIMIT 1000000;

-- 
SELECT s.date, 
round(SUM(g.gross_price * s.sold_quantity),2) AS gross_sale
FROM fact_sales_monthly s 
JOIN fact_gross_price g ON g.product_code = s.product_code AND g.fiscal_year = get_fiscal_year(s.date) 
WHERE customer_code = 90002002 GROUP BY s.date ORDER BY s.date;

-- top 5 markets
SELECT market, 
       ROUND(SUM(net_sales) / 1000000, 2) AS net_sales_mln
FROM net_sales 
GROUP BY market
ORDER BY net_sales_mln DESC
LIMIT 5;

-- top 5 product
SELECT product, 
       ROUND(SUM(net_sales) / 1000000, 2) AS net_sales_mln
FROM net_sales 
GROUP BY product
ORDER BY net_sales_mln DESC
LIMIT 5;

-- top 5 customer
SELECT customer, 
       ROUND(SUM(net_sales) / 1000000, 2) AS net_sales_mln
FROM net_sales 
GROUP BY customer
ORDER BY net_sales_mln DESC
LIMIT 5;

