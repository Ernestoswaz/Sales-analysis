=========================================================
   SALES PERFORMANCE ANALYSIS
   Author: Olawale Abiola
   Purpose: Analyze sales performance by product, customer, 
            and time to identify revenue drivers and trends
   ========================================================= */

-- Assumed table: sales_data
-- Columns: Index, Date, Month, Customer, Style, SKU, Size, Pcs, Rate, sales

   1. Overall Sales KPIs
   --------------------------------------------------------- */

SELECT
   COUNT(Index) AS total_orders,
    SUM(Pcs) AS total_units,
    SUM(sales) AS total_sales,
    ROUND(SUM(sales) / NULLIF(SUM(Pcs), 0), 2) AS avg_rate_per_unit

FROM
  Sales_data

/* ---------------------------------------------------------
   2. Sales Performance by SKU
   --------------------------------------------------------- */

SELECT
SKU,
    SUM(sales) AS total_sales,
    SUM(Pcs) AS total_units,
    ROUND(SUM(sales) / NULLIF(SUM(Pcs), 0), 2) AS avg_rate_per_unit
FROM 
   `dynamic-market-476712-i8.Sales_data.sales_report`
GROUP BY SKU
ORDER BY total_sales DESC;

/* ---------------------------------------------------------
   3. % Contribution of Each SKU (Pareto Analysis)
   --------------------------------------------------------- */

SELECT
    SKU,
    SUM(sales) AS total_sales,
    ROUND(
        SUM(sales) * 100.0 /
        SUM(SUM(sales)) OVER (),
        2
    ) AS percent_of_total_sales
FROM 
  `dynamic-market-476712-i8.Sales_data.sales_report`
GROUP BY SKU
ORDER BY total_sales DESC;

/* ---------------------------------------------------------
   4. Cumulative % of Sales (80/20 Rule)
   --------------------------------------------------------- */

SELECT
    SKU,
    total_sales,
    ROUND(
        SUM(total_sales) OVER (ORDER BY total_sales DESC)
        * 100.0 /
        SUM(total_sales) OVER (),
        2
    ) AS cumulative_sales_percentage
FROM (
    SELECT
        SKU,
        SUM(sales) AS total_sales
    FROM 
     `dynamic-market-476712-i8.Sales_data.sales_report`
    GROUP BY SKU
) t
ORDER BY total_sales DESC;


/* ---------------------------------------------------------
   5. Customer-wise Sales
   --------------------------------------------------------- */

SELECT
    Customer,
    SUM(sales) AS total_sales,
    SUM(Pcs) AS total_units,
    ROUND(SUM(sales) / NULLIF(SUM(Pcs), 0), 2) AS avg_rate_per_unit,
    ROUND(SUM(sales) * 100.0 / SUM(SUM(sales)) OVER (), 2) AS percent_of_total_sales
FROM 
 `dynamic-market-476712-i8.Sales_data.sales_report`
GROUP BY Customer
ORDER BY total_sales DESC;

/* ---------------------------------------------------------
   6. Top 5 SKUs by Sales
   --------------------------------------------------------- */

SELECT
    SKU,
    SUM(sales) AS total_sales,
    SUM(Pcs) AS total_units
FROM 
 `dynamic-market-476712-i8.Sales_data.sales_report`
GROUP BY SKU
ORDER BY total_sales DESC
LIMIT 5
