from flask import Flask, request, jsonify
import time
import json
import os

app = Flask(__name__)

DATA_FILE = "data.json"
TOKEN = "shenxianovo"

def load_data():
    if not os.path.exists(DATA_FILE):
        return {}
    with open(DATA_FILE, "r") as f:
        return json.load(f)

def save_data(data):
    with open(DATA_FILE, "w") as f:
        json.dump(data, f, indent=2)

@app.route("/heartbeat", methods=["POST"])
def heartbeat():
    data = request.json

    if not data or data.get("token") != TOKEN:
        return {"error": "unauthorized"}, 403

    devices = load_data()

    devices[data["device_id"]] = {
        "app_name": data["app_name"],
        "last_seen": time.time(),
    }

    save_data(devices)

    return {"status": "ok"}

@app.route("/status")
def status():
    devices = load_data()
    return jsonify(devices)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5001)