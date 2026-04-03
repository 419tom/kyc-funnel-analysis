-- Core KYC Funnel Metrics
WITH funnel_flags AS (
    SELECT
        u.user_id,

        MAX(CASE WHEN e.event_name = 'account_created' THEN 1 ELSE 0 END) AS account_created,
        MAX(CASE WHEN e.event_name = 'phone_verified' THEN 1 ELSE 0 END) AS phone_verified,
        MAX(CASE WHEN e.event_name = 'kyc_started' THEN 1 ELSE 0 END) AS kyc_started,
        MAX(CASE WHEN e.event_name = 'kyc_approved' THEN 1 ELSE 0 END) AS kyc_approved,
        MAX(CASE WHEN e.event_name = 'bank_linked' THEN 1 ELSE 0 END) AS bank_linked

    FROM users u
    LEFT JOIN kyc_events e
        ON u.user_id = e.user_id
    GROUP BY u.user_id
)

SELECT 'account_created' AS stage, SUM(account_created) AS users_reached
FROM funnel_flags

UNION ALL

SELECT 'phone_verified', SUM(phone_verified)
FROM funnel_flags

UNION ALL

SELECT 'kyc_started', SUM(kyc_started)
FROM funnel_flags

UNION ALL

SELECT 'kyc_approved', SUM(kyc_approved)
FROM funnel_flags

UNION ALL

SELECT 'bank_linked', SUM(bank_linked)
FROM funnel_flags;



-------


-- Funnel Conversion Rates
WITH funnel_flags AS (
    SELECT
        u.user_id,

        MAX(CASE WHEN e.event_name = 'account_created' THEN 1 ELSE 0 END) AS account_created,
        MAX(CASE WHEN e.event_name = 'phone_verified' THEN 1 ELSE 0 END) AS phone_verified,
        MAX(CASE WHEN e.event_name = 'kyc_started' THEN 1 ELSE 0 END) AS kyc_started,
        MAX(CASE WHEN e.event_name = 'kyc_approved' THEN 1 ELSE 0 END) AS kyc_approved,
        MAX(CASE WHEN e.event_name = 'bank_linked' THEN 1 ELSE 0 END) AS bank_linked

    FROM users u
    LEFT JOIN kyc_events e
        ON u.user_id = e.user_id
    GROUP BY u.user_id
),
funnel_counts AS (
    SELECT 'account_created' AS stage, SUM(account_created) AS users_reached FROM funnel_flags
    UNION ALL
    SELECT 'phone_verified', SUM(phone_verified) FROM funnel_flags
    UNION ALL
    SELECT 'kyc_started', SUM(kyc_started) FROM funnel_flags
    UNION ALL
    SELECT 'kyc_approved', SUM(kyc_approved) FROM funnel_flags
    UNION ALL
    SELECT 'bank_linked', SUM(bank_linked) FROM funnel_flags
),
base AS (
    SELECT users_reached AS total_users
    FROM funnel_counts
    WHERE stage = 'account_created'
)
SELECT
    f.stage,
    f.users_reached,
    ROUND(100.0 * f.users_reached / b.total_users, 2) AS conversion_from_signup_pct
FROM funnel_counts f
CROSS JOIN base b;
