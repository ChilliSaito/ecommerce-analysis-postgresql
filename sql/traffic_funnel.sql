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


