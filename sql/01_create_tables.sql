DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS kyc_events;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS user_feedback;


-- USERS TABLE
CREATE TABLE users (
    user_id TEXT PRIMARY KEY,
    signup_date TEXT,
    age_group TEXT,
    region TEXT,
    acquisition_channel TEXT,
    device_type TEXT
);


-- KYC EVENTS TABLE
CREATE TABLE kyc_events (
    event_id INTEGER PRIMARY KEY,
    user_id TEXT,
    event_name TEXT,
    event_timestamp TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- TRANSACTIONS TABLE
CREATE TABLE transactions (
    transaction_id TEXT PRIMARY KEY,
    user_id TEXT,
    transaction_date TEXT,
    transaction_type TEXT,
    amount REAL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- USER FEEDBACK TABLE
CREATE TABLE user_feedback (
    feedback_id INTEGER PRIMARY KEY,
    user_id TEXT,
    feedback_text TEXT,
    sentiment TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
