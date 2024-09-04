SELECT * FROM fact_act_est;

CREATE TABLE fact_act_est(SELECT 
s.date AS date,
s.product_code AS product_code,
s.customer_code AS customer_code,
s.sold_quantity AS sold_quantity,
f.forecast_quantity AS forecast_quantity
FROM fact_sales_monthly s
LEFT JOIN fact_forecast_monthly f
USING(date, product_code, customer_code)

UNION

SELECT 
s.date AS date,
s.product_code AS product_code,
s.customer_code AS customer_code,
s.sold_quantity AS sold_quantity,
f.forecast_quantity AS forecast_quantity
FROM fact_sales_monthly s
LEFT JOIN fact_forecast_monthly f
USING(date, product_code, customer_code));

-- net error
SELECT * FROM 
