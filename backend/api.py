from fastapi import FastAPI, UploadFile, File, HTTPException
import google.generativeai as genai
from PIL import Image
import io
import json
import os
import traceback

# Setup API Key (Akan diambil dari Environment Variable Server nanti)
genai.configure(api_key=os.environ.get("GOOGLE_API_KEY"))

# Setup Model
try:
    model = genai.GenerativeModel('gemini-2.0-flash-lite')
except:
    model = genai.GenerativeModel('gemini-flash-latest')

app = FastAPI()

def parse_nutrition_response(response_text):
    try:
        clean_text = response_text.replace("```json", "").replace("```", "").strip()
        return json.loads(clean_text)
    except:
        return None

@app.get("/")
def home():
    return {"status": "NutriGenius API is Running on Cloud! 🚀"}

@app.post("/analyze")
async def analyze_food_endpoint(file: UploadFile = File(...)):
    try:
        image_bytes = await file.read()
        image = Image.open(io.BytesIO(image_bytes))
        
        prompt = """
        Analyze this food image. Return ONLY a raw JSON string with this structure:
        {
            "identified_foods": ["food name"],
            "macronutrients": {"calories": 0, "protein": 0, "carbohydrates": 0, "fat": 0},
            "improvements": {"suggestions": ["tip 1"], "context": "feedback"}
        }
        """
        response = model.generate_content([prompt, image])
        parsed_data = parse_nutrition_response(response.text)
        
        if parsed_data is None:
             return {
                "identified_foods": ["Error"],
                "macronutrients": {"calories": 0, "protein": 0, "carbohydrates": 0, "fat": 0},
                "improvements": {"suggestions": [], "context": "JSON Error"}
            }
        return parsed_data
    except Exception as e:
        print(f"Error: {e}")
        raise HTTPException(status_code=500, detail=str(e))