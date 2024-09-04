	-- find post invoice discount
SELECT 
pre.date, pre.fiscal_year,
pre.customer_code, pre.market,
pre.product_code, pre.product, pre.variant,
pre.sold_quantity, pre.gross_sale,
pre.pre_invoice_discount_pct,
round((1-pre_invoice_discount_pct)*gross_sale,2) AS net_invoice_sales,
post.discounts_pct+post.other_deductions_pct AS post_invoice_discount
FROM gdb0041.pre_invoice_discount AS pre
JOIN fact_post_invoice_deductions AS post
ON post.date = pre.date AND
post.customer_code = pre.customer_code AND
post.product_code = pre.product_code;

-- net sale
SELECT post.date, post.fiscal_year, 
post.customer_code, c.customer,
post.market, 
post.product_code, post.product, post.variant, 
post.sold_quantity, post.gross_sale, 
post.pre_invoice_discount_pct, post.net_invoice_sales, 
post.post_invoice_discount, 
round((1-post_invoice_discount)*net_invoice_sales,2) AS net_sales
FROM post_invoice_discount AS post
JOIN dim_customer AS c
ON c.customer_code = post.customer_code;

-- TOP 3 MARKETS FY 2021
SELECT market, round(sum(net_sales)/1000000,2) AS net_sales_mln
FROM net_sales
WHERE fiscal_year = 2021
GROUP BY market
ORDER BY net_sales_mln DESC
LIMIT 3;

-- TOP 3 PRODUCTS FY 2021
SELECT product, round(sum(net_sales)/1000000,2) AS net_sales_mln
FROM net_sales
WHERE fiscal_year = 2021
GROUP BY product
ORDER BY net_sales_mln DESC
LIMIT 3;

-- TOP 3 CUSTOMERS FY 2021
SELECT customer, round(sum(net_sales)/1000000,2) AS net_sales_mln
FROM net_sales
WHERE fiscal_year = 2021
GROUP BY product
ORDER BY net_sales_mln DESC
LIMIT 3;

-- WINDOW FUNCTION--CREATE BAR CHART TOP 10 BY NS%
WITH cte1 AS (
    SELECT 
        customer, 
        ROUND(SUM(net_sales) / 1000000, 2) AS net_sales_mln,
        SUM(SUM(net_sales)) OVER () / 1000000 AS total_sales_mln
    FROM net_sales
    WHERE fiscal_year = 2021
    GROUP BY customer
)
SELECT 
    customer,
    round(net_sales_mln / total_sales_mln * 100,2) AS net_sale_pct
FROM cte1
ORDER BY net_sales_mln DESC;

-- WINDOW FUNCTION--CREATE PIE CHART TOP 10 BY NS% by region
WITH cte1 AS (
    SELECT 
        c.customer, c.region,
        round(sum(net_sales)/1000000,2)  AS net_sales_mln,
        round(sum(sum(net_sales)) OVER(PARTITION BY region)/1000000,2) AS net_sales_mln_by_region
    FROM net_sales ns
    JOIN dim_customer c
    ON c.customer_code=ns.customer_code
    WHERE fiscal_year = 2021
    GROUP BY c.customer,c.region
)
SELECT 
	customer, region,
	net_sales_mln,
    round(net_sales_mln * 100/ net_sales_mln_by_region,2) AS net_sale_pct_by_region
FROM cte1
ORDER BY region, net_sales_mln DESC;





