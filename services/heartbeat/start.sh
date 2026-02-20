#!/bin/bash
set -e

cd /srv/quqlab/services/heartbeat

if [ ! -d "venv" ]; then
    python3 -m venv venv
fi

source venv/bin/activate
pip install -r requirements.txt

pkill -f "services/heartbeat/app.py" || true

nohup venv/bin/python app.py > heartbeat.log 2>&1 &