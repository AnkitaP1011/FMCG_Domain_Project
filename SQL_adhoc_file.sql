create database ATILQMART;
use atilqmart;

#1 
SELECT distinct(a.product_name), b.base_price 
FROM dim_products a 
JOIN fact_events b ON a.product_code = b.product_code
WHERE b.promo_type = "BOGOF" AND b.base_price > 500;

#2
SELECT COUNT(store_id) AS count_of_store_id, city
FROM dim_stores
GROUP BY city
order by count_of_store_id asc;

#3
SELECT campaign_name,
       CONCAT(ROUND(SUM(revenue_before) / 1000000, 2), 'M') AS Revenue_before,
       CONCAT(ROUND(SUM(revenue_after) / 1000000, 2), 'M') AS Revenue_after
FROM fact_events
JOIN dim_campaigns ON fact_events.campaign_id = dim_campaigns.campaign_id
GROUP BY campaign_name;
select * from dim_campaigns;

#4
with Diwali_sale as
(
  select category, sum(isu) as ISU, 
  Round(SUM(isu)/ sum(quantity_sold_before_promo)*100,2) as ISU_Percentage
  from fact_events
  join dim_products ON fact_events.product_code = dim_products.product_code
  WHERE 
        campaign_id = 'CAMP_DIW_01'
    GROUP BY 
        category
)
select 
category,
ISU_Percentage,
rank() over(order by isu desc) as Ranking
from
diwali_sale;

#5
SELECT 
    Product_name, 
    Category, 
    CONCAT(ROUND(SUM(IR) / SUM(Revenue_before) * 100, 2), '%') AS IR_Percentage,
    RANK() OVER (ORDER BY SUM(IR) / SUM(Revenue_before) * 100 DESC) AS Ranking
FROM 
    fact_events
JOIN dim_products ON fact_events.product_code = dim_products.product_code
GROUP BY 
    Product_name, Category
ORDER BY 
    SUM(IR) / SUM(Revenue_before) DESC
LIMIT 5;


