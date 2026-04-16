SELECT * FROM "Data Practice"."UserEvents"
ORDER BY event_id;


--Defining sales funnel and different stages:
WITH funnel_stages AS (
    SELECT 
        COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS stage1_view,
        COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS stage2_cart,
        COUNT(DISTINCT CASE WHEN event_type = 'checkout_start' THEN user_id END) AS stage3_checkout,
        COUNT(DISTINCT CASE WHEN event_type = 'payment_info' THEN user_id END) AS stage4_info,
        COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS stage5_purchase
    FROM "Data Practice"."UserEvents"
    WHERE event_date >= CURRENT_DATE - INTERVAL '365 DAYS'
)

SELECT 
    stage1_view,
    stage2_cart,
    ROUND(stage2_cart * 100 / NULLIF(stage1_view, 0), 2) AS view_to_cart_ratio,
    stage3_checkout,
    ROUND(stage3_checkout * 100 / NULLIF(stage2_cart, 0), 2) AS cart_to_checkout_ratio,
    stage4_info,
    ROUND(stage4_info * 100 / NULLIF(stage3_checkout, 0), 2) AS checkout_to_info_ratio,
    stage5_purchase,
    ROUND(stage5_purchase * 100 / NULLIF(stage4_info, 0), 2) AS info_to_purchase_ratio
FROM funnel_stages;


--Defining source funnel:
WITH source_funnel AS (
    SELECT 
        traffic_source,
        COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS view,
        COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS cart,
        COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS purchase
    FROM "Data Practice"."UserEvents"
    WHERE event_date >= CURRENT_DATE - INTERVAL '365 DAYS'
    GROUP BY traffic_source
)

SELECT 
    traffic_source,
    view,
    cart,
	purchase,
    ROUND(cart * 100 / NULLIF(view, 0), 2) AS view_to_cart_ratio,
    ROUND(purchase * 100 / NULLIF(cart, 0), 2) AS cart_to_purchase_ratio
FROM source_funnel
ORDER BY purchase DESC;


--Defining time to conversion funnel:
WITH time_funnel AS (
    SELECT
        user_id,
        MIN(CASE WHEN event_type = 'page_view' THEN event_date END) AS view_time,
        MIN(CASE WHEN event_type = 'add_to_cart' THEN event_date END) AS cart_time,
        MIN(CASE WHEN event_type = 'purchase' THEN event_date END) AS purchase_time
    FROM "Data Practice"."UserEvents"
    WHERE event_date >= CURRENT_DATE - INTERVAL '365 DAYS'
    GROUP BY user_id
    HAVING 
    MIN(CASE WHEN event_type = 'purchase' THEN event_date END) IS NOT NULL
    AND MIN(CASE WHEN event_type = 'add_to_cart' THEN event_date END) IS NOT NULL
)

SELECT
    COUNT(*) AS converted_users,
    ROUND(AVG(EXTRACT(EPOCH FROM (cart_time - view_time)) / 60), 2) AS avg_view_to_cart_minutes,
    ROUND(AVG(EXTRACT(EPOCH FROM (purchase_time - cart_time)) / 60), 2) AS avg_cart_to_purchase_minutes
FROM time_funnel;


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