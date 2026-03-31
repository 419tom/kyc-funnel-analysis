import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import random
import os

# -----------------------------
# SETUP
# -----------------------------
np.random.seed(42)
random.seed(42)

os.makedirs("data/raw", exist_ok=True)

# -----------------------------
# 1. USERS TABLE
# -----------------------------
n_users = 2000
user_ids = np.arange(1001, 1001 + n_users)

signup_start = datetime(2025, 1, 1)
signup_dates = [signup_start + timedelta(days=np.random.randint(0, 90)) for _ in range(n_users)]

device_types = np.random.choice(["iOS", "Android", "Web"], size=n_users, p=[0.45, 0.45, 0.10])
acquisition_channels = np.random.choice(
    ["Organic", "Paid Social", "Referral", "Search"],
    size=n_users,
    p=[0.35, 0.30, 0.20, 0.15]
)
regions = np.random.choice(["Northeast", "South", "Midwest", "West"], size=n_users)
age_groups = np.random.choice(["18-24", "25-34", "35-44", "45-54"], size=n_users, p=[0.25, 0.40, 0.25, 0.10])

users = pd.DataFrame({
    "user_id": user_ids,
    "signup_date": signup_dates,
    "device_type": device_types,
    "acquisition_channel": acquisition_channels,
    "region": regions,
    "age_group": age_groups
})

users.to_csv("data/raw/users.csv", index=False)

# -----------------------------
# 2. KYC EVENTS TABLE
# -----------------------------
kyc_events = []

for _, row in users.iterrows():
    user_id = row["user_id"]
    signup_time = row["signup_date"] + timedelta(hours=np.random.randint(8, 22))

    # Base probabilities
    phone_verified = np.random.rand() < 0.92
    kyc_started = phone_verified and (np.random.rand() < 0.82)

    # Simulate realistic friction
    kyc_approval_prob = 0.78
    if row["device_type"] == "Android":
        kyc_approval_prob -= 0.08
    if row["acquisition_channel"] == "Paid Social":
        kyc_approval_prob -= 0.07

    bank_link_prob = 0.72

    # Account created
    kyc_events.append([user_id, "account_created", signup_time, None, None])

    if phone_verified:
        phone_time = signup_time + timedelta(minutes=np.random.randint(1, 30))
        kyc_events.append([user_id, "phone_verified", phone_time, None, None])

        if kyc_started:
            doc_type = np.random.choice(["Passport", "Driver License", "State ID"], p=[0.30, 0.50, 0.20])
            kyc_start_time = phone_time + timedelta(minutes=np.random.randint(5, 180))
            kyc_events.append([user_id, "kyc_started", kyc_start_time, doc_type, "started"])

            kyc_approved = np.random.rand() < kyc_approval_prob
            if kyc_approved:
                approval_delay = np.random.randint(10, 180) if doc_type == "Passport" else np.random.randint(30, 600)
                kyc_approved_time = kyc_start_time + timedelta(minutes=approval_delay)
                kyc_events.append([user_id, "kyc_approved", kyc_approved_time, doc_type, "approved"])

                bank_linked = np.random.rand() < bank_link_prob
                if bank_linked:
                    bank_time = kyc_approved_time + timedelta(hours=np.random.randint(1, 72))
                    kyc_events.append([user_id, "bank_linked", bank_time, None, "linked"])

kyc_events_df = pd.DataFrame(
    kyc_events,
    columns=["user_id", "event_name", "event_time", "kyc_document_type", "status"]
)
kyc_events_df.to_csv("data/raw/kyc_events.csv", index=False)

# -----------------------------
# 3. TRANSACTIONS TABLE
# -----------------------------
transactions = []
transaction_id = 5001

bank_linked_users = kyc_events_df[kyc_events_df["event_name"] == "bank_linked"]["user_id"].unique()

for user_id in bank_linked_users:
    bank_link_time = kyc_events_df[
        (kyc_events_df["user_id"] == user_id) &
        (kyc_events_df["event_name"] == "bank_linked")
    ]["event_time"].values[0]
    bank_link_time = pd.to_datetime(bank_link_time)

    # Deposit
    if np.random.rand() < 0.68:
        deposit_time = bank_link_time + timedelta(hours=np.random.randint(1, 120))
        deposit_amount = round(np.random.uniform(25, 500), 2)
        transactions.append([transaction_id, user_id, deposit_time, "deposit", deposit_amount, "success"])
        transaction_id += 1

        # Payment
        if np.random.rand() < 0.74:
            txn_time = deposit_time + timedelta(hours=np.random.randint(1, 240))
            txn_amount = round(np.random.uniform(5, 200), 2)
            transactions.append([transaction_id, user_id, txn_time, "payment", txn_amount, "success"])
            transaction_id += 1

transactions_df = pd.DataFrame(
    transactions,
    columns=["transaction_id", "user_id", "transaction_date", "transaction_type", "amount", "status"]
)
transactions_df.to_csv("data/raw/transactions.csv", index=False)

# -----------------------------
# 4. USER FEEDBACK TABLE (NLP)
# -----------------------------
positive_feedback = [
    "The signup process was easy",
    "Everything worked smoothly",
    "Fast and simple onboarding",
    "The app was very easy to use",
    "Verification was straightforward"
]

negative_feedback = [
    "The verification process is confusing",
    "App froze during document upload",
    "It took too long to verify my account",
    "I had trouble linking my bank",
    "The instructions were unclear"
]

neutral_feedback = [
    "I want to send money internationally",
    "I signed up to manage my spending",
    "I am exploring different payment apps",
    "I want an easier way to transfer money",
    "I am trying this app for the first time"
]

feedback_rows = []

approved_users = set(kyc_events_df[kyc_events_df["event_name"] == "kyc_approved"]["user_id"].unique())
started_users = set(kyc_events_df[kyc_events_df["event_name"] == "kyc_started"]["user_id"].unique())

for _, row in users.iterrows():
    user_id = row["user_id"]

    if user_id in approved_users:
        feedback = random.choice(positive_feedback + neutral_feedback)
        sentiment_label = "positive" if feedback in positive_feedback else "neutral"
    elif user_id in started_users:
        feedback = random.choice(negative_feedback + neutral_feedback)
        sentiment_label = "negative" if feedback in negative_feedback else "neutral"
    else:
        feedback = random.choice(neutral_feedback + negative_feedback)
        sentiment_label = "negative" if feedback in negative_feedback else "neutral"

    feedback_rows.append([user_id, feedback, sentiment_label])

feedback_df = pd.DataFrame(feedback_rows, columns=["user_id", "signup_feedback", "sentiment_label"])
feedback_df.to_csv("data/raw/user_feedback.csv", index=False)

# -----------------------------
# DONE
# -----------------------------
print("Synthetic fintech onboarding data generated successfully!")
print("Files created:")
print("- data/raw/users.csv")
print("- data/raw/kyc_events.csv")
print("- data/raw/transactions.csv")
print("- data/raw/user_feedback.csv")