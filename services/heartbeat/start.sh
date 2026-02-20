#!/bin/bash
set -e

cd /srv/quqlab/services/heartbeat

if [ ! -d "venv" ]; then
    python3 -m venv venv
fi

source venv/bin/activate
pip install -r requirements.txt

fuser -k 5001/tcp || true

nohup venv/bin/python app.py > heartbeat.log 2>&1 &