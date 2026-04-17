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


