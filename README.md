#  E-commerce Funnel Analysis (PostgreSQL)

##  Overview

This project analyzes user behavior across an e-commerce funnel using PostgreSQL. The goal is to understand how users move from initial interaction to purchase, identify drop-offs, evaluate traffic source performance, and measure conversion timing and revenue metrics.

The analysis is based on event-level data stored in a relational database, where each row represents a user action (e.g., page view, add to cart, purchase).

---

##  Dataset Description

The dataset (`UserEvents`) contains user activity with the following key fields:

* `user_id` → unique identifier for each user
* `event_type` → type of action (e.g., page_view, add_to_cart, purchase)
* `event_date` → timestamp of the event
* `traffic_source` → origin of the user (e.g., organic, paid, referral)
* `amount` → purchase value (only for purchase events)
* `event_id` → unique identifier for each event

---

##  Project Structure

```
sql/
├── sales_analysis.sql
├── traffic_funnel.sql
├── time_to_conversion_funnel.sql
└── revenue_analysis.sql
```

---

##  Key Insights:

**Focus on email as main source of traffic**
* The most valuable traffic source is emails with a conversion rate of 13%, in comparison to the driving traffic source, social media, which has
  a conversion rate of 6% but composes 30% of all views.

**Website optimization**
* The average time spent throughout the purchase process is slightly high, around 24 minutes from start to finish. However, the conversion rate for checkout-to-payment is over 80% overall, which is excellent. Therefor, the recommended action is to optimize UX/UI without making changes to the checkout.

**Ad expenses vs. AOV**
* The average order value is $115. If the cost of aquisition of a customer via social media exceeds $40, that constitutes a poor conversion, meaning money is being lost on those specific transactions.

---

##  Analysis Breakdown

### 1.  Sales Funnel Analysis

This query builds a full funnel:

**Stages:**

* Page View → Add to Cart → Checkout → Payment Info → Purchase

**Key Metrics:**

* Total users at each stage
* Conversion rates between steps:

  * View → Cart
  * Cart → Checkout
  * Checkout → Payment Info
  * Payment Info → Purchase

**Techniques Used:**

* Conditional aggregation (`CASE WHEN`)
* `COUNT(DISTINCT user_id)`
* CTEs for readability
* Safe division using `NULLIF`

---

### 2.  Traffic Source Funnel

This analysis breaks down funnel performance by acquisition channel.

**Key Insights:**

* Which traffic sources bring the most users
* Which sources convert best
* Comparison between volume vs efficiency

**Metrics:**

* Users per stage (view, cart, purchase)
* Conversion rates:

  * View → Cart
  * Cart → Purchase

**Techniques Used:**

* `GROUP BY traffic_source`
* Funnel logic per segment

---

### 3.  Time to Conversion Analysis

This section measures how long users take to move through the funnel.

**Key Metrics:**

* Average time (in minutes):

  * View → Add to Cart
  * Add to Cart → Purchase

**Logic:**

* First occurrence of each event per user using `MIN()`
* Time differences using PostgreSQL interval arithmetic

**Important Note:**
Only users who completed both steps (cart and purchase) are included.

**Techniques Used:**

* Timestamp subtraction
* `EXTRACT(EPOCH FROM interval)`
* Aggregation with `AVG()`

---

### 4.  Revenue Analysis

This section evaluates business performance metrics.

**Metrics:**

* Total views
* Total unique buyers
* Total orders
* Total revenue
* Average Order Value (AOV)
* Revenue per user

**Formulas:**

* AOV = total_revenue / total_orders
* Revenue per sale = total_revenue / total_sales

**Techniques Used:**

* Conditional aggregation
* SUM and COUNT combinations
* Derived metrics

---

##  Key SQL Concepts Demonstrated

* Common Table Expressions (CTEs)
* Conditional aggregation with `CASE WHEN`
* DISTINCT counting for user-level analysis
* Funnel analysis logic
* Time-based calculations using intervals
* Defensive SQL (`NULLIF` to avoid division by zero)
* Multi-step analytical queries

---

##  How to Run

1. Load the dataset into PostgreSQL:

   ```sql
   CREATE TABLE "Data Practice"."UserEvents" (...);
   ```

2. Import your data (CSV or other source)

3. Run each query from the `sql/` folder in pgAdmin or psql

---

##  Potential Extensions

* Conversion rate by device or geography
* Cohort analysis (user behavior over time)
* Median and percentile conversion times
* Funnel visualization using BI tools (Tableau, Power BI)
* A/B test analysis for conversion optimization

---

##  Project Goal

This project demonstrates the ability to:

* Translate business questions into SQL queries
* Analyze user behavior in a structured way
* Extract actionable insights from event data
* Communicate findings clearly

---

##  Summary

This analysis provides a complete view of the customer journey:

* Where users drop off
* Which channels perform best
* How long conversions take
* How much revenue is generated

It serves as a strong foundation for product, marketing, and growth decision-making.

---
