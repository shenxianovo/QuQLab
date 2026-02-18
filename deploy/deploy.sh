#!/bin/bash
set -e

# 1. 拉最新代码
cd /srv/quqlab
git reset --hard origin/main
git pull origin main

# 2. 同步 nginx 配置
sudo cp /srv/quqlab/deploy/nginx/quqlab.conf /etc/nginx/sites-available/quqlab.conf
sudo ln -sf /etc/nginx/sites-available/quqlab.conf /etc/nginx/sites-enabled/quqlab.conf

# 3. 测试 nginx 配置
sudo nginx -t

# 4. reload nginx
sudo systemctl reload nginx
