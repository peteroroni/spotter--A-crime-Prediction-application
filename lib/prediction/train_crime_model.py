import pandas as pd
import os
import joblib
from sklearn.preprocessing import LabelEncoder
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report

# Load dataset
df = pd.read_csv("crimes.csv")

# Drop rows with critical missing values
df = df.dropna(subset=["location", "time", "date", "lat", "long", "category"])

# Convert date to datetime and extract day of week
df["date"] = pd.to_datetime(df["date"], errors='coerce')
df = df.dropna(subset=["date"])
df["day_of_week"] = df["date"].dt.day_name()

# Merge categories into broader groups
def merge_category(cat):
    cat = cat.lower()
    if "robbery" in cat or "snatching" in cat:
        return "robbery-related"
    elif "assault" in cat or "battery" in cat or "domestic" in cat:
        return "assault-related"
    elif "drug" in cat:
        return "drug-related"
    elif "traffic" in cat or "reckless" in cat:
        return "traffic-related"
    elif "murder" in cat or "kidnapping" in cat or "harrasment" in cat:
        return "violent-crime"
    elif "burglary" in cat or "fraud" in cat:
        return "property-related"
    else:
        return "other"

df["crime_group"] = df["category"].apply(merge_category)

# Encode features
location_encoder = LabelEncoder()
day_encoder = LabelEncoder()
crime_encoder = LabelEncoder()

df["location_encoded"] = location_encoder.fit_transform(df["location"])
df["day_encoded"] = day_encoder.fit_transform(df["day_of_week"])
df["crime_encoded"] = crime_encoder.fit_transform(df["crime_group"])

# Define features and target
X = df[["location_encoded", "day_encoded", "lat", "long"]]
y = df["crime_encoded"]

# Train/test split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Train Random Forest
model = RandomForestClassifier(n_estimators=100, random_state=42)
model.fit(X_train, y_train)

# Evaluate
y_pred = model.predict(X_test)
print(classification_report(y_test, y_pred, target_names=crime_encoder.classes_))

# Save model and encoders
os.makedirs("model", exist_ok=True)
joblib.dump(model, "model/crime_rf_model.pkl")
joblib.dump(location_encoder, "model/location_encoder.pkl")
joblib.dump(day_encoder, "model/day_encoder.pkl")
joblib.dump(crime_encoder, "model/crime_encoder.pkl")
