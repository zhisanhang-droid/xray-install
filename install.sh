#!/bin/bash

# ============================================================
# Xray Reality 一键安装脚本
# 适用于：Ubuntu 20.04+ / Debian 10+ / CentOS 8+ / OpenCloudOS
# 作者：自用脚本，按需修改
# ============================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log()    { echo -e "${GREEN}[✓]${NC} $1"; }
warn()   { echo -e "${YELLOW}[!]${NC} $1"; }
error()  { echo -e "${RED}[✗]${NC} $1"; exit 1; }
info()   { echo -e "${BLUE}[>]${NC} $1"; }

# ---- 检查 root ----
[ "$EUID" -ne 0 ] && error "请使用 root 用户运行此脚本（sudo -i 后再执行）"

echo ""
echo "========================================"
echo "       Xray Reality 一键安装脚本        "
echo "========================================"
echo ""

# ---- 安装 Docker ----
if ! command -v docker &>/dev/null; then
    info "检测到未安装 Docker，开始安装..."
    curl -fsSL https://get.docker.com | sh
    systemctl enable docker
    systemctl start docker
    log "Docker 安装完成"
else
    log "Docker 已安装：$(docker --version)"
fi

# ---- 创建目录 ----
mkdir -p /opt/xray
cd /opt/xray

# ---- 生成密钥 ----
info "生成 Reality 密钥..."
KEYS=$(docker run --rm ghcr.io/xtls/xray-core:latest x25519 2>/dev/null)
PRIVATE_KEY=$(echo "$KEYS" | grep "PrivateKey" | awk '{print $2}')
PUBLIC_KEY=$(echo  "$KEYS" | grep "Password"   | awk '{print $2}')
UUID=$(docker run --rm ghcr.io/xtls/xray-core:latest uuid 2>/dev/null)
SHORT_ID=$(openssl rand -hex 8)
SERVER_IP=$(curl -s ifconfig.me)

log "密钥生成完成"

# ---- 写入 config.json ----
cat > /opt/xray/config.json << EOF
{
  "log": { "loglevel": "warning" },
  "inbounds": [
    {
      "listen": "0.0.0.0",
      "port": 8443,
      "protocol": "vless",
      "settings": {
        "clients": [
          { "id": "${UUID}", "flow": "xtls-rprx-vision" }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "tcp",
        "security": "reality",
        "realitySettings": {
          "show": false,
          "dest": "www.microsoft.com:443",
          "serverNames": ["www.microsoft.com"],
          "privateKey": "${PRIVATE_KEY}",
          "shortIds": ["${SHORT_ID}"]
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls"]
      }
    }
  ],
  "outbounds": [
    { "protocol": "freedom", "tag": "direct" },
    { "protocol": "blackhole", "tag": "block" }
  ],
  "routing": {
    "domainStrategy": "IPIfNonMatch",
    "rules": [
      { "type": "field", "ip": ["geoip:private"], "outboundTag": "block" }
    ]
  }
}
EOF

# ---- 写入 docker-compose.yml ----
cat > /opt/xray/docker-compose.yml << EOF
services:
  xray:
    image: ghcr.io/xtls/xray-core:latest
    container_name: xray
    restart: unless-stopped
    ports:
      - "8443:8443"
    volumes:
      - ./config.json:/etc/xray/config.json:ro
    command: run -c /etc/xray/config.json
EOF

# ---- 开放端口 ----
info "开放防火墙端口 8443..."
if command -v ufw &>/dev/null; then
    ufw allow 8443/tcp &>/dev/null && log "ufw 已放行 8443"
elif command -v firewall-cmd &>/dev/null && firewall-cmd --state &>/dev/null; then
    firewall-cmd --permanent --add-port=8443/tcp &>/dev/null
    firewall-cmd --reload &>/dev/null && log "firewalld 已放行 8443"
else
    iptables -I INPUT -p tcp --dport 8443 -j ACCEPT && log "iptables 已放行 8443"
fi

# ---- 启动服务 ----
info "启动 Xray 服务..."
docker compose down &>/dev/null || true
docker compose up -d
sleep 3

if docker ps | grep -q xray; then
    log "Xray 服务启动成功"
else
    error "Xray 启动失败，请运行 'docker logs xray' 查看日志"
fi

# ---- 保存连接信息 ----
VLESS_LINK="vless://${UUID}@${SERVER_IP}:8443?encryption=none&flow=xtls-rprx-vision&security=reality&sni=www.microsoft.com&fp=chrome&pbk=${PUBLIC_KEY}&sid=${SHORT_ID}&type=tcp#MyProxy"

cat > /opt/xray/client-info.txt << EOF
========================================
        Xray Reality 连接信息
========================================
服务器 IP   : ${SERVER_IP}
端口        : 8443
UUID        : ${UUID}
公钥 (pbk)  : ${PUBLIC_KEY}
ShortID     : ${SHORT_ID}
伪装域名    : www.microsoft.com

VLESS 链接（复制到客户端导入）：
${VLESS_LINK}
========================================
EOF

echo ""
echo -e "${GREEN}========================================"
echo "          安装完成！"
echo -e "========================================${NC}"
echo ""
cat /opt/xray/client-info.txt
echo ""
echo -e "${YELLOW}连接信息已保存到：/opt/xray/client-info.txt${NC}"
echo ""
