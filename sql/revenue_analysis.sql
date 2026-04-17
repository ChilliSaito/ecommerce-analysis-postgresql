--Revenue analysis:
WITH revenue_funnel AS (
    SELECT
        ROUND(COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END), 2) AS total_views,
        ROUND(COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END), 2) AS total_sales,
		ROUND(COUNT(CASE WHEN event_type = 'purchase' THEN 1 END), 2) AS total_orders,
		SUM(CASE WHEN event_type = 'purchase' THEN amount END) AS total_revenue
    FROM "Data Practice"."UserEvents"
    WHERE event_date >= CURRENT_DATE - INTERVAL '365 DAYS'
)

SELECT
	total_views,
	total_sales,
	total_orders,
	total_revenue,
	total_revenue / total_orders AS avg_order_value,
	total_revenue / total_sales AS avg_revenue_per_sale
FROM revenue_funnel;
