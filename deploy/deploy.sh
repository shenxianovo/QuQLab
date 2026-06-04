#!/bin/bash
set -e

# 1. 拉最新代码
cd /srv/quqlab
git reset --hard origin/main
git pull origin main

# 2. 同步 nginx 配置(rsync 镜像 sites-available,仓库为唯一源)
SRC=/srv/quqlab/deploy/nginx/sites-available/
DST=/etc/nginx/sites-available/

# 只镜像 *.conf:服务器上多余的 .conf 会被删除,非 .conf 的发行版文件保留
sudo rsync -a --delete --include='*.conf' --exclude='*' "$SRC" "$DST"

# 按 sites-available 中的 .conf 重建 sites-enabled 软链
for conf in "$DST"*.conf; do
    sudo ln -sf "$conf" "/etc/nginx/sites-enabled/$(basename "$conf")"
done

# 清理 sites-enabled 中的失效软链(源 .conf 已被 rsync 删除,如旧 quqlab.conf)
sudo find /etc/nginx/sites-enabled/ -xtype l -delete

# 3. 测试 nginx 配置
sudo nginx -t

# 4. reload nginx
sudo systemctl reload nginx
