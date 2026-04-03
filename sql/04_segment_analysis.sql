-- Funnel performance by segment
WITH user_stage_flags AS (
    SELECT
        u.user_id,
        u.device_type,
        u.acquisition_channel,
        u.region,
        u.age_group,

        MAX(CASE WHEN e.event_name = 'account_created' THEN 1 ELSE 0 END) AS account_created,
        MAX(CASE WHEN e.event_name = 'phone_verified' THEN 1 ELSE 0 END) AS phone_verified,
        MAX(CASE WHEN e.event_name = 'kyc_started' THEN 1 ELSE 0 END) AS kyc_started,
        MAX(CASE WHEN e.event_name = 'kyc_approved' THEN 1 ELSE 0 END) AS kyc_approved,
        MAX(CASE WHEN e.event_name = 'bank_linked' THEN 1 ELSE 0 END) AS bank_linked

    FROM users u
    LEFT JOIN kyc_events e
        ON u.user_id = e.user_id
    GROUP BY
        u.user_id,
        u.device_type,
        u.acquisition_channel,
        u.region,
        u.age_group
)

SELECT
    device_type,
    COUNT(*) AS total_users,
    SUM(kyc_started) AS users_started_kyc,
    SUM(kyc_approved) AS users_approved_kyc,
    ROUND(100.0 * SUM(kyc_approved) / COUNT(*), 2) AS kyc_approval_rate_pct
FROM user_stage_flags
GROUP BY device_type
ORDER BY kyc_approval_rate_pct DESC;
