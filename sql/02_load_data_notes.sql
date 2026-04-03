-- Notes for loading CSV files into SQLite

-- This project typically loads data using Python/Pandas
-- rather than raw SQL imports.

-- Expected CSV files:
-- users.csv
-- kyc_events.csv
-- transactions.csv
-- user_feedback.csv

-- Example Python loading approach:
-- df_users.to_sql("users", conn, if_exists="replace", index=False)
-- df_events.to_sql("kyc_events", conn, if_exists="replace", index=False)
-- df_txns.to_sql("transactions", conn, if_exists="replace", index=False)
-- df_feedback.to_sql("user_feedback", conn, if_exists="replace", index=False)

-- If using SQLite CLI manually:
-- .mode csv
-- .import data/raw/users.csv users
-- .import data/raw/kyc_events.csv kyc_events
-- .import data/raw/transactions.csv transactions
-- .import data/raw/user_feedback.csv user_feedback
