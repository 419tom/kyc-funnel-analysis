-- Time from signup to KYC approval / first transaction
WITH user_milestones AS (
    SELECT
        u.user_id,
        u.signup_date,

        MIN(CASE WHEN e.event_name = 'kyc_approved' THEN e.event_timestamp END) AS kyc_approved_ts,
        MIN(t.transaction_date) AS first_transaction_date

    FROM users u
    LEFT JOIN kyc_events e
        ON u.user_id = e.user_id
    LEFT JOIN transactions t
        ON u.user_id = t.user_id
    GROUP BY u.user_id, u.signup_date
)

SELECT
    user_id,
    signup_date,
    kyc_approved_ts,
    first_transaction_date,

    ROUND(julianday(kyc_approved_ts) - julianday(signup_date), 2) AS days_to_kyc_approval,
    ROUND(julianday(first_transaction_date) - julianday(signup_date), 2) AS days_to_first_transaction

FROM user_milestones;
