from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import joblib
import numpy as np
import uvicorn

# Load model and encoders
model = joblib.load("lib/prediction/model/crime_rf_model.pkl")
location_encoder = joblib.load("lib/prediction/model/location_encoder.pkl")
day_encoder = joblib.load("lib/prediction/model/day_encoder.pkl")
crime_encoder = joblib.load("lib/prediction/model/crime_encoder.pkl")

app = FastAPI(title="Crime Type Prediction API")

class PredictionInput(BaseModel):
    location: str
    day_of_week: str
    latitude: float
    longitude: float

class PredictionOutput(BaseModel):
    predicted_crime_group: str
    probability_distribution: dict

@app.post("/predict", response_model=PredictionOutput)
def predict_crime(input: PredictionInput):
    try:
        location_enc = location_encoder.transform([input.location])[0]
        day_enc = day_encoder.transform([input.day_of_week])[0]
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))

    features = np.array([[location_enc, day_enc, input.latitude, input.longitude]])
    pred = model.predict(features)[0]
    probs = model.predict_proba(features)[0]

    return {
        "predicted_crime_group": crime_encoder.inverse_transform([pred])[0],
        "probability_distribution": {
            crime_encoder.inverse_transform([i])[0]: round(float(p), 4)
            for i, p in enumerate(probs)
        }
    }

if __name__ == "__main__":
    uvicorn.run("main:app", port=8000, reload=True)
