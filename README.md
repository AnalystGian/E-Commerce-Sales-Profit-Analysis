# E-Commerce-Sales-Profit-Analysis

# Background
The business operates an e-commerce platform selling products across multiple categories and regions. Transaction-level data is collected for each record, capturing order date, product, category, region, quantity sold, sales revenue, and profit.
Despite having detailed transactional data, stakeholders lack clear visibility into the true drivers of revenue, profitability, and performance efficiency across products, categories, regions, and time.

# Objectives
This project aims to answer the following core questions:
1. Which products and categories drive revenue and profit?
2. How do sales and profit vary across regions?
3. Which products sell in high volume but generate low profit?
4. How does business performance evolve over time?

The goal is to transform raw transactional data into actionable insights that support pricing, product strategy, operational optimization, and long-term business growth.

# Data Source
https://www.kaggle.com/datasets/sidramazam/e-commerce-sales-performance-analysis


# Dataset Overview & Assumptions
3,500 e-commerce transaction records

7 structured fields:

Order Date

Product Name

Category

Region

Quantity

Sales (Revenue)

Profit

# Key Assumptions
Each row represents a single transaction record

Sales is treated as revenue

Profit is provided directly (cost breakdown not available)

No customer-level or order-level identifiers are present

# Scope Limitation
Analysis focuses on business insights and decision-making, not data cleaning or predictive modeling.

# Key Findings
1. Business is profitable with ₱10.67M sales, ₱1.84M profit, 17.29% margin.

2. 2024 weakened vs 2023: Sales and profit declined, and margin fell to approximately 16.69% in 2024.

3. Electronics drives profit with 50% of total profit comes from Electronics and Accessories 40%.

4. Top products by profit are Camera and Monitor, while Laptop has the strongest margin of 18.5%.

5. No consistently unprofitable products.

6. West is the strongest region, while North has the lowest margin, especially North + Office having 14.6% margin.

7. Margin risk appears in specific months. Worst month is Nov 2024 which has 14.46% while best margin is Dec 2023 with 20.13%.

8. Selling more units doesn’t automatically improve margin. Strategy should focus on mix and pricing.

# Recommendations
1. Protect and scale profit engines
Prioritize Electronics and high-performing products (Camera/Monitor/Laptop) for marketing and stock reliability.

2. Optimize low-margin volume products
Review Tablet and Printer pricing, supplier costs, or bundles to lift margin.

3. Fix regional margin drag
Investigate North + Office performance: adjust assortment, test price positioning, reduce low-margin mix.

4. Diagnose margin dips
Drill down into low-margin months (Nov 2024) by category/product/region to identify what changed.

5. Shift from “growth = volume” to “growth = profitable mix”
Since margin doesn’t rise with volume, focus on mix optimization and pricing discipline.
