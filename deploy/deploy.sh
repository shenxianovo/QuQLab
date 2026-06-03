#!/bin/bash
set -e

# 1. 拉最新代码
cd /srv/quqlab
git reset --hard origin/main
git pull origin main

# 2. 同步 nginx 配置
sudo cp /srv/quqlab/deploy/nginx/quqlab.conf /etc/nginx/sites-available/quqlab.conf
sudo ln -sf /etc/nginx/sites-available/quqlab.conf /etc/nginx/sites-enabled/quqlab.conf

# AuthService 入口(TLS 终止 -> 前端容器),宿主 nginx 统一在此同步
sudo cp /srv/quqlab/deploy/nginx/auth.conf /etc/nginx/sites-available/auth.conf
sudo ln -sf /etc/nginx/sites-available/auth.conf /etc/nginx/sites-enabled/auth.conf

# 3. 测试 nginx 配置
sudo nginx -t

# 4. reload nginx
sudo systemctl reload nginx
