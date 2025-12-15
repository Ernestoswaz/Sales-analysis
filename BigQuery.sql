=========================================================
   SALES PERFORMANCE ANALYSIS
   Author: Olawale Abiola
   Purpose: Analyze sales performance by product, customer, 
            and time to identify revenue drivers and trends
   ========================================================= */

-- Assumed table: sales_data
-- Columns: Index, Date, Month, Customer, Style, SKU, Size, Pcs, Rate, Gross_amount

/* ---------------------------------------------------------
   1. Overall Sales KPIs
   --------------------------------------------------------- */
SELECT
    COUNT(Index) AS total_orders,
    SUM(Pcs) AS total_units,
    SUM(Gross_amount) AS total_sales,
    ROUND(SUM(Gross_amount) / NULLIF(SUM(Pcs), 0), 2) AS avg_rate_per_unit
FROM sales_data;


/* ---------------------------------------------------------
   2. Sales Performance by SKU
   --------------------------------------------------------- */
SELECT
    SKU,
    SUM(Gross_amount) AS total_sales,
    SUM(Pcs) AS total_units,
    ROUND(SUM(Gross_amount) / NULLIF(SUM(Pcs), 0), 2) AS avg_rate_per_unit
FROM sales_data
GROUP BY SKU
ORDER BY total_sales DESC;


/* ---------------------------------------------------------
   3. % Contribution of Each SKU (Pareto Analysis)
   --------------------------------------------------------- */
SELECT
    SKU,
    SUM(Gross_amount) AS total_sales,
    ROUND(
        SUM(Gross_amount) * 100.0 /
        SUM(SUM(Gross_amount)) OVER (),
        2
    ) AS percent_of_total_sales
FROM sales_data
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
        SUM(Gross_amount) AS total_sales
    FROM sales_data
    GROUP BY SKU
) t
ORDER BY total_sales DESC;


/* ---------------------------------------------------------
   5. Monthly Sales Trend
   --------------------------------------------------------- */
SELECT
    Month,
    SUM(Gross_amount) AS monthly_sales,
    SUM(Pcs) AS monthly_units,
    ROUND(SUM(Gross_amount) / NULLIF(SUM(Pcs), 0), 2) AS avg_rate_per_unit
FROM sales_data
GROUP BY Month
ORDER BY Month;


/* ---------------------------------------------------------
   6. Customer-wise Sales
   --------------------------------------------------------- */
SELECT
    Customer,
    SUM(Gross_amount) AS total_sales,
    SUM(Pcs) AS total_units,
    ROUND(SUM(Gross_amount) / NULLIF(SUM(Pcs), 0), 2) AS avg_rate_per_unit,
    ROUND(SUM(Gross_amount) * 100.0 / SUM(SUM(Gross_amount)) OVER (), 2) AS percent_of_total_sales
FROM sales_data
GROUP BY Customer
ORDER BY total_sales DESC;


/* ---------------------------------------------------------
   7. Top 5 SKUs by Sales
   --------------------------------------------------------- */
SELECT
    SKU,
    SUM(Gross_amount) AS total_sales,
    SUM(Pcs) AS total_units
FROM sales_data
GROUP BY SKU
ORDER BY total_sales DESC
LIMIT 5;
