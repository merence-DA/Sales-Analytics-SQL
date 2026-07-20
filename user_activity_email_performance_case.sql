/*******************************************************************************
  Description: User Account Creation & Email Activity Performance Analysis
  
  Purpose:
  - Aggregates user account registrations and email metrics (sent, opened, clicked)
  - Calculates country-level totals and ranks top 10 performing markets
  - Prepares structured data for Looker Studio dashboards
  
  Dialect: Google BigQuery Standard SQL
*******************************************************************************/

-- 1. CTE: Calculate user account registration metrics
WITH account_info AS (
    SELECT
        s.date AS date,
        sp.country AS country,
        ac.send_interval AS send_interval,
        ac.is_verified AS is_verified,
        ac.is_unsubscribed AS is_unsubscribed,
        COUNT(DISTINCT ac.id) AS account_cnt,
        0 AS sent_msg,
        0 AS open_msg,
        0 AS visit_msg
    FROM `DA.account` AS ac
    INNER JOIN `DA.account_session` AS acs 
        ON ac.id = acs.account_id
    INNER JOIN `DA.session_params` AS sp 
        ON acs.ga_session_id = sp.ga_session_id
    INNER JOIN `DA.session` AS s 
        ON s.ga_session_id = sp.ga_session_id
    GROUP BY 
        s.date, 
        sp.country, 
        ac.send_interval, 
        ac.is_verified, 
        ac.is_unsubscribed
),

-- 2. CTE: Calculate email engagement metrics
email_info AS (
    SELECT
        DATE_ADD(s.date, INTERVAL es.sent_date DAY) AS date,
        sp.country AS country,
        ac.send_interval AS send_interval,
        ac.is_verified AS is_verified,
        ac.is_unsubscribed AS is_unsubscribed,
        0 AS account_cnt,
        COUNT(DISTINCT es.id_message) AS sent_msg,
        COUNT(DISTINCT eo.id_message) AS open_msg,
        COUNT(DISTINCT ev.id_message) AS visit_msg
    FROM `DA.email_sent` AS es
    LEFT JOIN `DA.email_open` AS eo 
        ON es.id_message = eo.id_message AND es.id_account = eo.id_account
    LEFT JOIN `DA.email_visit` AS ev 
        ON es.id_message = ev.id_message AND es.id_account = ev.id_account
    INNER JOIN `DA.account` AS ac 
        ON es.id_account = ac.id
    INNER JOIN `DA.account_session` AS acs 
        ON ac.id = acs.account_id
    INNER JOIN `DA.session` AS s 
        ON acs.ga_session_id = s.ga_session_id
    INNER JOIN `DA.session_params` AS sp 
        ON s.ga_session_id = sp.ga_session_id
    GROUP BY 
        DATE_ADD(s.date, INTERVAL es.sent_date DAY), 
        sp.country, 
        ac.send_interval, 
        ac.is_verified, 
        ac.is_unsubscribed
),

-- 3. CTE: Combine account and email data
union_all AS (
    SELECT * FROM account_info
    UNION ALL
    SELECT * FROM email_info
),

-- 4. CTE: Aggregate metrics by dimensions
aggregated AS (
    SELECT
        date,
        country,
        send_interval,
        is_verified,
        is_unsubscribed,
        SUM(account_cnt) AS account_cnt,
        SUM(sent_msg) AS sent_msg,
        SUM(open_msg) AS open_msg,
        SUM(visit_msg) AS visit_msg
    FROM union_all
    GROUP BY 
        date, 
        country, 
        send_interval, 
        is_verified, 
        is_unsubscribed
),

-- 5. CTE: Country-level totals via window functions
country_totals AS (
    SELECT 
        *,
        SUM(account_cnt) OVER (PARTITION BY country) AS total_country_account_cnt,
        SUM(sent_msg) OVER (PARTITION BY country) AS total_country_sent_cnt
    FROM aggregated
),

-- 6. CTE: Rank countries by total accounts and sent emails
ranked AS (
    SELECT 
        *,
        DENSE_RANK() OVER (ORDER BY total_country_account_cnt DESC) AS rank_total_country_account_cnt,
        DENSE_RANK() OVER (ORDER BY total_country_sent_cnt DESC) AS rank_total_country_sent_cnt
    FROM country_totals
)

-- Final Selection: Filter for Top 10 countries in either category
SELECT *
FROM ranked
WHERE rank_total_country_account_cnt <= 10 
   OR rank_total_country_sent_cnt <= 10;
