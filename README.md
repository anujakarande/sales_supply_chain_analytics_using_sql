Objective:
The primary goal of this project is to build a robust framework for Atliq Hardware that delivers actionable insights to enhance their operational strategy. These insights, derived from an in-depth analysis of key data sources such as customer behavior, transaction history, product trends, and regional dynamics, will empower Atliq Hardware to make data-driven decisions that align with market demands and consumer preferences.

Atliq Hardware's Business Model:
Atliq Hardware sells its products to various customers like Croma, BestBuy, Amazon, and Flipkart. These customers, in turn, sell the products to end consumers. The company uses three sales channels:

Retailers
Direct sales via Atliq's own stores
Distributors
The profit and loss analysis for Atliq Hardware involves several key steps:

Gross Sales: The price at which Atliq sells its products (e.g., $30 for a mouse).
Pre-Invoice Deductions: Yearly discount agreements made at the start of each fiscal year, e.g., $2 deduction.
Post-Invoice Deductions: Discounts provided by Atliq for promotional offers, prime placement fees, or performance rebates (e.g., 5% or 10% discounts).
Net Sales: Calculated by subtracting pre- and post-invoice deductions from gross sales.
Cost of Goods Sold (COGS): Includes manufacturing, freight, and other costs.
Gross Margin: Net sales minus COGS.
Data Infrastructure:
The project uses a star schema with the following tables:

Customer Table: Stores information about customers, enabling analysis of demographics, buying behavior, and preferences.
Post-Invoice Deductions Table: Contains information on post-invoice deduction amounts.
Pre-Invoice Deductions Table: Contains information on pre-invoice deduction amounts.
Manufacturing Cost Table: Contains data related to COGS.
Gross Price Table: Contains gross price data for each product.
Forecast Monthly Table: Contains forecast data for product quantities.
Products Table: Stores information about the products offered by Atliq Hardware.
Sales Table: Aggregates sales data, providing insights into revenue trends and sales performance.
Fiscal Year:
The fiscal year for Atliq starts in September and ends in August. All analyses are performed within this fiscal year framework.

Project Management Methodology:
The project follows the Kanban methodology, with a focus on limiting work in progress to enhance efficiency and focus. Jira is used as the project management tool.

Problem Statements and Solutions:

Individual Product Sales Report:

Generate a report on monthly product sales for CROMA India for FY 2021, including fields like Month, Product Name, Variant, Sold Quantity, Gross Price per item, and Gross Price Total.
A user-defined function was created to convert calendar dates to the fiscal year and fiscal quarter.
The report is generated using SQL queries that incorporate fiscal year logic.
Aggregate Monthly Gross Sales Report:

Generate a report on aggregate monthly gross sales for CROMA India to track sales performance.
A stored procedure was created to automate the generation of gross sales reports for any customer.
Market Badge Calculation:

Create a stored procedure to determine market badges based on total sales quantity, categorizing markets as Gold or Silver.
SQL queries were used to retrieve total quantities and apply logic for badge determination.
KPI Reports:

Generate reports on the top and bottom 5 markets, products, and customers by net sales.
The net sales were calculated by subtracting pre- and post-invoice deductions from gross sales using views to simplify calculations.
Top 10 Markets by % Net Sales:

Prepare a bar chart report for FY 2021, showing the top 10 markets by percentage of net sales.
Window functions were used to calculate market share percentages.
