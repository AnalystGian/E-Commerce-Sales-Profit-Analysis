-- E-COMMERCE SALES & PROFITABILITY ANALYSIS (PostgreSQL)
-------------------------------------------------------------------------
-- Business Context:
-- The business operates an e-commerce platform selling products across multiple
-- categories and regions. Transaction-level data is captured per record, including
-- order date, product, category, region, quantity sold, sales (revenue), and profit.

-- Stakeholder Questions:
-- - Which products and categories drive revenue and profit?
-- - How do sales and profit vary across regions?
-- - Which items sell in high volume but generate low profit?
-- - How does business performance change over time?

-- Assumptions / Limitations:
-- - Each row represents a transaction record (no order_id/customer_id available).
-- - Sales is treated as revenue; Profit is given directly (no cost breakdown).



-- Now, let's see whether the business is operating on a sustainable, profit-focused foundation before
-- we proceed to deeper analysis.

-- 1.1. How many total transactions are recorded in the dataset?
SELECT COUNT(*) AS total_transactions
FROM ecommerce_sales_data;
-- 3,500 transactions recorded, meaning, we have a solid volume for performance analysis.



-- 1.2. How healthy is the business overall? What is the total sales and total profit?
SELECT 
	SUM("Sales") AS total_sales,
	SUM("Profit") AS total_profit,
	ROUND(SUM("Profit") / (SUM("Sales")), 4) AS profit_margin,
	ROUND(AVG("Sales"), 2)  AS avg_transaction_sales,
	ROUND(AVG("Profit"), 2) AS avg_transaction_profit
FROM ecommerce_sales_data;
-- Total sales: ₱10,667,881
-- Total profit: ₱1,844,665.21
-- Overall profit margin: 17.29%
-- Avg transaction sales: ₱3,047.97
-- Avg transaction profit: ₱527.05

-- The business is profitably operating and not just having high-volume. A 17.29% margin is healthy,
-- but improvements likely come from product mix + margin optimization, not just selling more. But we
-- will dig more to see which drive the performance.



-- 2.1. Are sales and profit growing year over year?
SELECT *
FROM ecommerce_sales_data

SELECT
	CAST(DATE_TRUNC('year', "Order Date") AS DATE) AS year,
	COUNT(*) AS transactions,
	SUM("Sales") AS total_sales,
	SUM("Profit") AS total_profit,
	ROUND(SUM("Profit") / (SUM("Sales")), 4) AS profit_margin
FROM ecommerce_sales_data
GROUP BY 1
ORDER BY 1;
-- in 2022 ₱3,255,970 sales, ₱572,856.98 profit, 17.59% margin
-- in 2023 ₱3,786,592 sales, ₱666,866.42 profit, 17.61% margin
-- in 2024 ₱3,625,319 sales, ₱604,941.81 profit, 16.69% margin

-- Growth peaked in 2023, then softened in 2024, the sales drops by ~4.3%, the profit drops
-- by ~9.3%, the profit margin is down also. This suggests margin pressure or less favorable
-- product/region mix in 2024.

-- Also, although sales and transaction volume increased significantly from 2022 to 2023, profit
-- margin remained nearly flat because profit grew at almost the same rate as revenue. This
-- indicates that growth was primarily volume-driven, with stable pricing, cost structures, and
-- product mix. The business successfully scaled without sacrificing profitability, suggesting
-- disciplined cost control.



-- 2.2. What are monthly sales/profit trends and margin stability?
SELECT *
FROM ecommerce_sales_data

SELECT
	CAST(DATE_TRUNC('month', "Order Date") AS DATE) AS month,
	COUNT(*) AS transactions,
	SUM("Sales") AS total_sales,
	SUM("Profit") AS total_profit,
	ROUND(SUM("Profit") / (SUM("Sales")), 4) AS profit_margin
FROM ecommerce_sales_data
GROUP BY 1
ORDER BY 1;
-- It's hard to find which is which so let's create a temporary table of the above code to see the following:
-- month with highest sales?
-- month with best margin?
-- month with lowest sales?
-- month with worst margin?

CREATE TEMP TABLE monthly_trends AS
    SELECT
        CAST(DATE_TRUNC('month', "Order Date") AS DATE) AS months,
        COUNT(*) AS transactions,
        SUM("Sales") AS total_sales,
        SUM("Profit") AS total_profit,
        ROUND(SUM("Profit") / NULLIF(SUM("Sales"), 0), 4) AS profit_margin
    FROM ecommerce_sales_data
    GROUP BY 1

 -- month with highest sales?
SELECT
	months,
	total_sales
FROM monthly_trends
ORDER BY total_sales DESC
LIMIT 1;
-- Aug 2023 has the highest sale which is ₱388,428.00

-- month with lowest sales?
SELECT
	months,
	total_sales
FROM monthly_trends
ORDER BY total_sales ASC
LIMIT 1;
-- Feb 2024 has the lowest sale which is ₱179,708.00

-- month with best margin?
SELECT
	months,
	profit_margin
FROM monthly_trends
ORDER BY profit_margin DESC
LIMIT 1;
-- Dec 2023 has the best profit margin with 20.13%

-- month with worst margin?
SELECT
	months,
	profit_margin
FROM monthly_trends
ORDER BY profit_margin ASC
LIMIT 1;
-- -- Nov 2024 has the worst profit margin with 14.46%

-- Overall, we can see that seasonality exists, but the bigger signal is margin volatility,
-- especially the margin dip in late 2024.

-- 2.3 Which months have unusually low profit margins? (15% threshold)
SELECT
	months,
	total_sales,
	total_profit,
	profit_margin
FROM monthly_trends
WHERE profit_margin < 0.15;
-- At least one month drops below 15% margin, notably Nov 2024 with 14.46% profit margin.
-- This month should be investigated by product/region mix to identify what drove margin
-- compression.



-- 3.1 Which categories drive revenue and profit?
SELECT *
FROM ecommerce_sales_data

SELECT
	"Category",
	COUNT(*) AS transactions,
	SUM("Quantity") AS total_units_sold,
	SUM("Sales") AS total_sales,
	SUM("Profit") AS total_profit,
	ROUND(SUM("Profit") / (SUM("Sales")), 4) AS profit_margin,
	ROUND(SUM("Profit") / SUM(SUM("Profit")) OVER (), 4) AS profit_share
FROM ecommerce_sales_data
GROUP BY 1
ORDER BY total_profit DESC;
-- We can see that Electronics has ₱5.33M sales, ₱923.19K profit, and approximately 50.0% of total profit.
-- Also, Accessories has ₱4.25M sales, ₱736.08K profit, and approximately 39.9% of total profit. While
-- Office has ₱1.09M sales, ₱185.39K profit, and approximately 10.1% of total profit

-- Electronics is the primary profit engine. Office is small and slightly lower margin which 
-- is good a candidate for improvement.



-- 4.1 Which products drive the most value?
SELECT *
FROM ecommerce_sales_data

SELECT
	"Product Name",
	COUNT(*) AS transactions,
	SUM("Quantity") AS total_units_sold,
	SUM("Sales") AS total_sales,
	SUM("Profit") AS total_profit,
	ROUND(SUM("Profit") / (SUM("Sales")), 4) AS profit_margin
FROM ecommerce_sales_data
GROUP BY 1
ORDER BY total_profit DESC;
-- We can see that Camera, Monitor, Mouse, Laptop, and Printer are the top profit products.
-- Also, the Laptop has the best margin of 18.47% while tablet has the lowest margin of
-- 16.36% which is still profitable.

-- Profitability is fairly consistent, but Tablet and Printer underperform margin-wise relative
-- to top products.



-- 4.2 -- Identify products that sell a lot but have relatively low margins.
-- The threshold is based on average quantity sold and 25% bottom of products by margin.
SELECT *
FROM ecommerce_sales_data

WITH product_metrics AS (
    SELECT
        "Product Name",
        SUM("Quantity") AS total_units_sold,
        SUM("Sales") AS total_sales,
        SUM("Profit") AS total_profit,
        SUM("Profit") / SUM("Sales") AS profit_margin
    FROM ecommerce_sales_data
    GROUP BY 1
),
benchmarks AS (
    SELECT
        AVG(total_units_sold) AS avg_units,
		percentile_cont(0.25) WITHIN GROUP (ORDER BY profit_margin) AS margin_p25
    FROM product_metrics
)
SELECT
    pm."Product Name",
    pm.total_units_sold,
    pm.total_sales,
    pm.total_profit,
    ROUND(pm.profit_margin::numeric, 4) AS profit_margin
FROM product_metrics pm
CROSS JOIN benchmarks b
WHERE pm.total_units_sold >= b.avg_units
  AND pm.profit_margin <= margin_p25
ORDER BY pm.profit_margin ASC, pm.total_units_sold DESC;
-- This will surface “popular but margin-light” products. Based on our actual metrics, Tablet, Printer,
-- Smartwatch are products sold with high volume but low profit margins. These are prime candidates for
-- pricing review, or maybe supplier renegotiation, bundling strategies, or promotion tuning.



-- 4.3 Are any products unprofitable on average?
SELECT
	"Product Name",
	ROUND(AVG("Profit" / "Sales"), 4) AS avg_profit_margin
FROM ecommerce_sales_data
GROUP BY 1
HAVING AVG("Profit" / "Sales") <= 0
ORDER BY avg_profit_margin ASC;
-- Obviously, it returns no rows, meaning, no product is consistently unprofitable.



-- 5.1 -- Which regions are strongest, and which are margin-challenged?
SELECT
	"Region",
	COUNT(*) AS transactions,
	SUM("Quantity") AS total_units_sold,
	SUM("Sales") AS total_sales,
	SUM("Profit") AS total_profit,
	SUM("Profit") / SUM("Sales") AS profit_margin
FROM ecommerce_sales_data
GROUP BY 1
ORDER BY total_profit DESC;
-- We can see here that West is the strongest region, generating the highest total profit of approximately ₱495.36K 
-- and the best profit margin of 17.41%. North has the lowest margin of 17.13%, but it remains healthy and above a
-- 15% profitability threshold. Overall, regional margins are tightly clustered, suggesting differences in profitability
-- are driven more by sales volume than major margin gaps.



-- 5.2 Where are margin gaps happening (region + category)?
SELECT
	"Region",
	"Category",
	SUM("Sales") AS total_sales,
	SUM("Profit") AS total_profit,
	SUM("Profit") / SUM("Sales") AS profit_margin
FROM ecommerce_sales_data
GROUP BY 1, 2
ORDER BY profit_margin ASC;
-- North & Office margin is notably low having 14.58% margin compared to other combinations. This combination
-- is a clear optimization target. We can check pricing, product mix, shipping/ops costs if possible, or
-- promotional intensity in North, Office.



-- 6.1 Does selling more units increase profit margin?
SELECT
	DISTINCT("Quantity")
FROM ecommerce_sales_data

SELECT
	"Quantity",
    ROUND(AVG("Profit" / "Sales")::numeric, 4) AS avg_profit_margin
FROM ecommerce_sales_data
GROUP BY 1
ORDER BY avg_profit_margin
-- We can see that margins are nearly flat across quantity, there is no strong volume to margin relationship.
-- Increasing volume alone doesn’t reliably improve margins. Profit improvement will come more from product/category
-- mix and pricing/cost tactics.