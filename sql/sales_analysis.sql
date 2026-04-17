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


