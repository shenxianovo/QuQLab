#!/bin/bash
set -e

# 1. 拉最新代码
cd /srv/quqlab
git reset --hard origin/main
git pull origin main

# 2. 同步 nginx 配置(sites-available 为源,按文件夹对应服务器布局)

# 主站 shenxianovo.com
sudo cp /srv/quqlab/deploy/nginx/sites-available/main.conf /etc/nginx/sites-available/main.conf
sudo ln -sf /etc/nginx/sites-available/main.conf /etc/nginx/sites-enabled/main.conf

# chat.shenxianovo.com -> chat 后端容器
sudo cp /srv/quqlab/deploy/nginx/sites-available/chat.conf /etc/nginx/sites-available/chat.conf
sudo ln -sf /etc/nginx/sites-available/chat.conf /etc/nginx/sites-enabled/chat.conf

# auth.shenxianovo.com 入口(TLS 终止 -> 前端容器),宿主 nginx 统一在此同步
sudo cp /srv/quqlab/deploy/nginx/sites-available/auth.conf /etc/nginx/sites-available/auth.conf
sudo ln -sf /etc/nginx/sites-available/auth.conf /etc/nginx/sites-enabled/auth.conf

# 3. 测试 nginx 配置
sudo nginx -t

# 4. reload nginx
sudo systemctl reload nginx
