import pandas as pd
import firebase_admin
from firebase_admin import credentials, firestore

# Step 1: Initialize Firebase Admin
cred = credentials.Certificate("serviceAccountKey.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

# Step 2: Load CSV
df = pd.read_csv("crimes.csv")

# Optional: Parse/clean datetime
df['datetime'] = pd.to_datetime(df['date'] + ' ' + df['time'], errors='coerce')

# Step 3: Upload each row to Firestore
collection_name = "CrimeReports"

for index, row in df.iterrows():
    data = {
        "date": row["date"],
        "time": row["time"],
        "latitude": float(row["lat"]),
        "longitude": float(row["long"]),
        "location": row["location"],
        "crime_type": row["category"],
        "description": row["description"],
        "datetime": row["time_classification"]
    }
    db.collection(collection_name).add(data)

print(f"Uploaded {len(df)} records to Firestore collection '{collection_name}'")
