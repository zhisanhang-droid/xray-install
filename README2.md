# VPS 选购与使用完全指南：科学上网 × 跑 Claude Code

> 写给真正在用 AI 干活的人。不绕弯子，直接说怎么选、怎么装、踩过什么坑。

---

## 前言：买 VPS 到底为了什么？

很多人买 VPS 是因为别人说"有个服务器挺好的"，买完之后发现不知道怎么用，放在那里每个月扣钱。

在聊怎么选之前，先搞清楚自己的需求。VPS 的用途大致分两类：

**用途 A：科学上网（代理工具）**
国内访问 ChatGPT、Claude、Google、GitHub 时经常遇到障碍。自建代理比买机场更稳定、更私密，一台低配 VPS 完全够用。

**用途 B：跑 Claude Code（AI 主机）**
Claude Code 默认只能在本地电脑用，关机就断。把它部署在 VPS 上，手机、iPad、任意设备随时打开浏览器就能用，Claude 的任务可以在后台持续跑。

这两种需求对服务器的要求**完全不同**，选错了白花钱。下面分开来讲。

---

## Part A：用 VPS 做科学上网

### A1 选服务器：哪些指标真的重要

很多人买服务器时盯着 CPU 核数、内存大小。做代理的话，这两个几乎不重要。真正影响使用体验的是这几个：

**① 地区（最重要）**

代理服务器的位置决定了两件事：你到服务器的延迟，以及服务器到目标网站的速度。

对国内用户来说，**新加坡** 是公认的性价比首选：
- 到国内的延迟一般在 30–60ms，比美西（150ms+）流畅得多
- 新加坡网络基础设施好，连 Google、YouTube、Claude 都快
- 各大云厂商都有新加坡节点，可选余地多

如果你主要访问美国的服务（比如某些只有美区的网站），也可以考虑美西洛杉矶节点，延迟高一些但访问美国服务更直接。

**② IP 质量（比配置更重要）**

同样的配置，干净的 IP 和被污染的 IP，使用体验天壤之别。

什么是"脏 IP"：被大量用户滥用过、被 Google 要求验证码、被 Netflix 封锁、甚至直接被 GFW 盯上的 IP。

买之前可以用以下方式检测 IP 质量：
- 搜索 `ip.sb` 或 `ipinfo.io`，查看 IP 归属和风险评分
- 用 `ping` 测延迟
- 开通后第一件事：测试能不能访问 Google、YouTube、ChatGPT

**③ 带宽和流量**

代理几乎不吃 CPU 和内存，吃的是带宽。

日常使用（刷 YouTube 1080P、开会用 Zoom）：5–20 Mbps 上行带宽够用
重度使用（多设备同时用、频繁下载）：50 Mbps+

大多数 VPS 的带宽标注的是"共享带宽"，实际速度比标注值低是正常的。如果服务商标注 1 Gbps，实际能跑到 100 Mbps 就很好了。

流量方面，个人使用每月 100–500 GB 通常足够。很多服务商提供 1 TB/月的套餐，基本不用担心超限。

**④ 配置要求**

做代理对配置要求极低：
- 最低可用：1 核 512 MB 内存
- 舒适配置：1 核 1 GB 内存
- 完全没必要买 2 核 4 GB 来做代理，那是浪费

---

### A2 主流服务商对比 & 避坑

**腾讯云轻量应用服务器**

优点：国内公司，支付宝/微信付款，客服有中文，新加坡节点稳定，IP 质量普遍不错。新用户有优惠活动，性价比高。

适合人群：不想折腾、要稳定、第一次买 VPS 的人。

注意：腾讯云国内节点无法访问 Anthropic/Google，**必须选境外节点**（新加坡、硅谷等）。

**Vultr**

优点：按小时计费，不满意随时删掉换节点，IP 被封换一个新的成本很低。全球多个数据中心，灵活。

缺点：只支持信用卡或 PayPal，国内用户支付不太方便。

适合人群：折腾党、需要灵活换 IP 的用户。

**搬瓦工（BandwagonHost）**

优点：老牌服务商，CN2 GIA 线路质量好，国内访问延迟低、速度稳。

缺点：价格偏高，便宜套餐经常断货，需要海外支付方式。

适合人群：对速度要求高、愿意为稳定付溢价的用户。

**RackNerd**

优点：价格极低，经常有黑五促销，年付几十元人民币能拿到不错的配置。

缺点：IP 质量参差不齐，运气成分较大，服务器性能不稳定。

适合人群：预算很低、愿意赌一赌的用户。

**要避开的情况：**
- 国内服务商的国内节点（直接访问境外服务受限）
- 宣传"无限流量"的低价 VPS（多半是超卖）
- 在淘宝、拼多多买"VPS"（质量无保障，随时跑路）

---

### A3 协议选择：用什么跑代理

**不推荐的老协议：**

Shadowsocks：曾经的主流，现在特征识别已经很成熟，裸跑容易被封。

V2Ray + WebSocket + TLS：需要自己的域名，配置复杂，性能不如新协议。

**现在最推荐：Xray + VLESS + REALITY**

这是目前抗封锁能力最强的方案，原理简单说：

普通代理会暴露"这是代理流量"的特征，防火墙通过流量分析可以识别并封锁。REALITY 协议让你的代理流量**完全伪装成访问微软、苹果等大公司网站的 HTTPS 流量**，防火墙看到的是正常的 TLS 握手，无从区分。

更重要的是：**REALITY 不需要你自己购买域名和 SSL 证书**，直接借用其他网站的证书做伪装，省去了一大堆配置。

---

### A4 服务端部署：一步步来

以下以 Ubuntu 22.04 为例（推荐这个系统：稳定、社区文档多、出问题容易找到解决方案）。

**Step 1：登录服务器**

```bash
ssh root@你的服务器IP
```

建议第一件事改掉默认 SSH 端口并禁用密码登录，只用密钥登录，防止被暴力破解。

**Step 2：更新系统**

```bash
apt update && apt upgrade -y
```

**Step 3：安装 Xray**

官方提供一键安装脚本：

```bash
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install
```

安装完成后 Xray 会作为系统服务运行。

**Step 4：生成 REALITY 密钥对**

```bash
xray x25519
```

输出类似：
```
Private key: xxxxxx...（私钥，服务端用）
Public key:  xxxxxx...（公钥，客户端用）
```

把这两个值保存好。

**Step 5：生成 UUID（用户 ID）**

```bash
xray uuid
```

同样保存好输出的 UUID。

**Step 6：配置 Xray**

编辑配置文件：

```bash
nano /usr/local/etc/xray/config.json
```

写入以下内容（替换对应字段）：

```json
{
  "inbounds": [
    {
      "port": 8443,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "你的UUID",
            "flow": "xtls-rprx-vision"
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "tcp",
        "security": "reality",
        "realitySettings": {
          "serverNames": ["www.microsoft.com"],
          "privateKey": "你的私钥",
          "shortIds": ["你生成的shortId"]
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom"
    }
  ]
}
```

生成 shortId：

```bash
openssl rand -hex 8
```

**Step 7：开放防火墙端口**

```bash
ufw allow 8443/tcp
ufw enable
```

如果用的是云服务商的安全组（腾讯云、阿里云等），还需要在控制台的"安全组"里放行对应端口。

**Step 8：启动 Xray**

```bash
systemctl restart xray
systemctl enable xray
systemctl status xray
```

看到 `active (running)` 就成功了。

---

### A5 客户端配置（四端）

配置信息共四个关键参数，准备好：
- 服务器 IP 和端口
- UUID
- REALITY 公钥（Public Key）
- Short ID

**导入方式优先级：二维码 > 链接 > 手动填写**

推荐用链接或二维码导入，手动填写最容易漏字段，出了问题也不好排查。

**Android：v2rayNG**

下载：GitHub releases 页面搜索 `2dust/v2rayNG`

操作：打开 app → 右上角 `+` → 扫码或粘贴链接导入 → 点击连接

导入后进节点详情检查一遍：协议类型、地址、端口、UUID、Security 是否都有值。

**iPhone / iPad：Streisand 或 Shadowrocket**

Streisand 免费，Shadowrocket 付费（约 $2.99，需要非国区 Apple ID）。

Streisand 完全够用，推荐新手从这个开始。

导入：打开 app → 右上角 `+` → 扫码或链接导入

**特别注意**：iPhone 上用聊天软件（微信、iMessage）收到的 vless 链接，容易被自动换行或截断，导致导入失败。建议用二维码，或把链接发到备忘录里再复制。

**Windows：v2rayN**

下载：GitHub 搜索 `2dust/v2rayN`，下载 `v2rayN-With-Core` 版本（包含所有依赖）

操作：解压 → 运行 v2rayN.exe → 服务器 → 添加 VLESS 服务器，或从剪贴板导入链接

设置系统代理模式（全局 or 规则模式），连接后浏览器自动走代理。

**macOS：Shadowrocket 或 v2rayN**

v2rayN 现在支持 macOS，免费，操作和 Windows 版基本一致。

Shadowrocket 体验更流畅，支持规则分流，有 Mac App Store 版本。

---

### A6 常见问题

**连得上但网速很慢**

先测一下服务器本身的网速（在服务器上跑 `curl -s https://speedtest.net` 或用 speedtest-cli）。如果服务器网速本身没问题，检查客户端是否开启了 `xtls-rprx-vision` 流控，这个对速度影响很大。

**时断时续**

可能是 IP 被 QoS 限速（运营商对部分境外 IP 进行限速）。换个时间段测试，晚高峰（20:00–23:00）通常最拥堵。换端口（比如从 8443 改到 443）有时能改善。

**IP 被封了**

主要表现：ping 不通，或者能 ping 通但代理完全不工作。

处理方式：
- Vultr 用户：删掉服务器重建，重新分配一个 IP（数据记得备份）
- 腾讯云：联系客服申请更换 IP，或者重新购买
- 短期临时方案：换端口后用 Cloudflare CDN 中转（配置复杂，不详述）

**客户端导入后字段丢失**

REALITY 的字段（Public Key、Short ID）在某些旧版客户端保存后会丢失。解决方法：更新客户端到最新版，重新导入。导入完成后进节点详情再检查一遍再连接。

---

## Part B：用 VPS 跑 Claude Code

### B1 这个方案解决什么问题

Claude Code 是 Anthropic 官方的 CLI 工具，能在终端里让 Claude 读代码、写代码、执行任务。但它默认只能在本地电脑用——你得开着电脑，在终端里操作，换台设备就什么都没了。

把 Claude Code 部署在 VPS 上，再配上 CloudCLI UI（一个开源的浏览器端界面），就可以做到：
- 手机、iPad、任意电脑打开浏览器就能用
- Claude 的任务在后台持续运行，不依赖你本地的机器
- 切换设备无缝衔接，历史记录都在

适合人群：重度 Claude 用户、经常出差或多设备切换的人、想让 Claude 跑长任务的人。

---

### B2 选服务器：和代理需求完全不同

**① 地区要求：必须能直连 Anthropic API**

Claude Code 需要实时和 Anthropic 的 API 通信。Anthropic 不对中国大陆 IP 提供服务，所以：

- **国内服务器完全不可用**（即便是腾讯云、阿里云的境外节点，部分也有 API 访问限制，需要测试）
- 推荐：美国（硅谷、弗吉尼亚）、日本、新加坡节点
- 实测延迟：服务器到 Anthropic API 的延迟影响每次响应速度，美国节点最快（因为 Anthropic 服务器在美国）

**② 配置要求：比代理高，但不需要很高**

Claude Code 本身很轻量，但如果同时跑多个项目、配上其他服务（n8n、数据库等），就需要更多资源：

| 场景 | 推荐配置 |
|------|----------|
| 只跑 Claude Code + UI | 1C1G 勉强，1C2G 流畅 |
| 同时跑 2–3 个项目 | 2C2G |
| 多服务并行（n8n、数据库等） | 2C4G 或以上 |

**③ 网速影响**

上行带宽影响代码文件上传速度，下行影响 API 响应和文件下载。但实际上，使用 Claude Code 的瓶颈几乎不在带宽，而在 **API 响应延迟**——这取决于服务器到 Anthropic 的网络质量，不是你家宽带决定的。

普通 VPS 的 10–100 Mbps 带宽对 Claude Code 使用完全够用。

**④ 推荐服务商**

**Oracle Cloud 永久免费套餐（最强性价比）**

Oracle 提供真正永久免费的 ARM 实例：4 核 CPU + 24 GB 内存 + 200 GB 硬盘，带宽 1 Gbps。这个配置在其他服务商要花不少钱，Oracle 给你白嫖。

缺点：注册需要信用卡验证，新账号有时会被风控拒绝；ARM 架构对部分软件有兼容性问题（大多数情况下无影响）；免费实例某些区域抢不到（可以多试几个区域）。

可用区域：美国东部、美国西部、日本大阪、新加坡等。

**AWS Lightsail**

价格透明，$5/月起，稳定性好，适合不想折腾的人。有免费试用期。

**Vultr**

$6/月起，按小时计费，随用随停，全球节点多，适合测试或短期使用。

---

### B3 基础环境搭建

系统选 **Ubuntu 22.04 LTS**。

**安全加固（必做）**

```bash
# 创建非 root 用户
adduser claude
usermod -aG sudo claude

# 禁用 root 密码登录（建议配置 SSH 密钥后再做这步）
# 编辑 /etc/ssh/sshd_config
PermitRootLogin no
PasswordAuthentication no

# 重启 SSH
systemctl restart sshd

# 配置防火墙
ufw allow 22/tcp    # SSH
ufw allow 80/tcp    # HTTP
ufw allow 443/tcp   # HTTPS
ufw enable
```

**安装 Node.js 22+**

```bash
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
apt install -y nodejs
node --version  # 确认 v22+
```

**安装 pm2（进程守护）**

```bash
npm install -g pm2
pm2 startup  # 设置开机自启
```

**安装 nginx**

```bash
apt install -y nginx
systemctl enable nginx
```

---

### B4 安装 Claude Code + CloudCLI UI

**安装 Claude Code**

```bash
npm install -g @anthropic-ai/claude-code
```

配置 API Key：

```bash
export ANTHROPIC_API_KEY="你的API Key"
# 或写入 ~/.bashrc 永久生效
echo 'export ANTHROPIC_API_KEY="你的API Key"' >> ~/.bashrc
source ~/.bashrc
```

验证是否能连上：

```bash
claude --version
claude "hello"  # 测试一下
```

**安装 CloudCLI UI**

CloudCLI UI 是 claudecodeui 的开源浏览器端界面，让你用浏览器操作 Claude Code。

```bash
cd ~
git clone https://github.com/siteboon/claudecodeui.git
cd claudecodeui
npm install
npm run build
```

用 pm2 启动并守护：

```bash
pm2 start npm --name "claudecodeui" -- run server
pm2 save
```

默认监听 3001 端口。

---

### B5 nginx 反代 + SSL

**为什么不直接暴露端口**

直接用 `http://IP:3001` 访问有几个问题：
- 没有 HTTPS，数据明文传输
- 浏览器会提示不安全
- WebSocket 连接在某些网络环境下容易断

配置 nginx 反代，再加上 SSL 证书，就可以用 `https://你的域名` 访问，安全且稳定。

**先申请一个域名**

推荐 Cloudflare 管理域名，DNS 解析生效快，后续还能用 Cloudflare Access 做认证。把 A 记录指向你的 VPS IP。

**nginx 配置**

创建配置文件：

```bash
nano /etc/nginx/conf.d/claudeui.conf
```

写入：

```nginx
server {
    listen 80;
    server_name 你的域名;

    location / {
        proxy_pass http://127.0.0.1:3001;
        proxy_http_version 1.1;

        # WebSocket 支持（Claude Code 流式输出必须）
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_read_timeout 300s;
        proxy_connect_timeout 10s;
    }
}
```

**申请 SSL 证书（Certbot）**

```bash
apt install -y certbot python3-certbot-nginx
certbot --nginx -d 你的域名
```

按提示输入邮箱、同意条款，自动配置完成。证书 90 天有效，Certbot 会自动续期。

```bash
nginx -t && systemctl reload nginx
```

---

### B6 访问安全（必做）

部署完如果不加任何认证，任何知道你域名的人都可以用你的 Claude Code——相当于把你的 API Key 白送出去。

**推荐方案：Cloudflare Access（免费，最省事）**

如果你的域名托管在 Cloudflare：

1. 进入 Cloudflare 控制台 → Zero Trust → Access → Applications
2. 添加应用，选择 Self-hosted，填入你的域名
3. 配置访问策略（比如只允许你的邮箱登录）
4. Cloudflare 会在你访问域名时弹出一个登录页，输入邮箱收验证码，验证后才能进入

这个方案不需要修改任何服务器配置，完全在 Cloudflare 层面拦截，安全可靠。

**备选方案：nginx Basic Auth**

```bash
apt install -y apache2-utils
htpasswd -c /etc/nginx/.htpasswd 你的用户名

# 在 nginx 配置的 location 块里加：
auth_basic "Restricted";
auth_basic_user_file /etc/nginx/.htpasswd;
```

简单粗暴，但每次访问都要输密码，用起来麻烦一些。

---

### B7 常见问题

**打开页面白屏**

先看 pm2 日志确认服务在跑：

```bash
pm2 logs claudecodeui
```

再看 nginx 日志：

```bash
tail -f /var/log/nginx/error.log
```

常见原因：npm run build 没跑完、端口被防火墙拦、nginx 配置语法错误。

**WebSocket 断连（手机用最常见）**

主要表现：Claude 在回复中途突然停止，刷新后才能继续。

原因：手机网络不稳定，或者中间有代理/负载均衡器超时切断了 WebSocket 连接。

解决：在 nginx 配置里把 `proxy_read_timeout` 调到 600s，加上 WebSocket keepalive 相关配置。

**API 连接超时**

```bash
# 在服务器上测试能否访问 Anthropic
curl https://api.anthropic.com
```

如果不通，说明服务器 IP 无法访问 Anthropic。换区域或换服务商。

**内存不够用**

Claude Code 在处理大项目时会占用较多内存。如果服务器内存不足（小于 1GB），可以临时加 swap：

```bash
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' >> /etc/fstab
```

---

## Part C：我自己是怎么用的

说一下我自己的实际方案，给有同样需求的人参考。

### 我的配置

日常科学上网这块，用的是**腾讯云轻量应用服务器，新加坡节点，最低配（1 核 1 GB）**，跑 Xray + VLESS + REALITY 协议。

选腾讯云的原因说几个实际的：

第一，**支付太方便了**。支付宝直接付，不用折腾海外信用卡，账单一目了然，也不担心信用卡被盗刷。

第二，**新手友好**。控制台是中文，遇到问题有中文客服，出问题也容易找到解决方案。对第一次摸服务器的人来说，这个真的很重要，能省掉很多时间。

第三，**新加坡节点稳**。我试过几家服务商，腾讯云新加坡这条线路整体比较稳定，晚高峰也不会太夸张地降速。对比过 Vultr 同区域，腾讯云的 IP 质量在我用的这段时间里明显更干净，没有触发 Google 验证码的问题。

第四，**有活动的时候真的便宜**。新用户优惠、续费活动，算下来比很多"便宜 VPS"性价比还高，关键是稳定性有保障。

### 部署思路

协议选 VLESS + REALITY，理由前面讲了——不需要自己的域名，伪装效果好，配置完之后基本不用动。

服务端部署用的是 Xray 官方的安装脚本，大约 10 分钟搞定。配置文件改的东西不多，主要是 UUID、REALITY 密钥对、端口这几个。

安全组这边只开了代理用的端口和 SSH，其他全关，尽量减少暴露面。

### 多端同步

四台设备（iPhone、iPad、Mac、Windows 备用机），用的同一个节点，导入方式是二维码。

**强烈建议把二维码图片保存起来**，存在手机相册或者云盘里。不然哪天手机坏了，重装 app 又要重新配置，还不如直接扫一下省事。

不要通过聊天软件传 vless 链接给自己，微信尤其会把长链接截断，导入必然失败。要传就传二维码图片，或者用自己的备忘录 app 保存链接原文。

### 实际体验

用下来大概说几点真实感受：

**延迟**：日常延迟在 40–60ms 左右，刷 YouTube 4K 稳，Claude、ChatGPT 响应很快，Zoom 开会没出现过问题。

**稳定性**：部署完之后基本不需要维护。偶尔 Xray 服务会因为系统更新重启，设置了 systemd 自启之后自动恢复，基本感知不到。真正需要手动处理的情况，几个月里遇到过一次，是 IP 被临时限速，过了两天自己好了。

**成本**：一个月开销不多，比买机场省，而且自己的节点没有隐私顾虑。

### 建议新手从哪里开始

如果你现在完全没有节点，建议这个顺序：

1. 腾讯云买一台新加坡轻量，最低配就够，先试试
2. 跟着 Xray 官方文档或者本文 A4 的步骤，装好服务端
3. 手机装 Streisand（iOS）或 v2rayNG（Android），扫码导入测试
4. 能用了再考虑配 Windows/Mac 客户端

整个过程第一次做大概需要 1–2 小时，踩坑的时间看个人。成功之后再折腾优化，比一上来就研究各种高级配置效率高多了。

---

## 总结

| | 代理上网 | 跑 Claude Code |
|---|---|---|
| 推荐地区 | 新加坡 | 美国 / 日本 |
| 最低配置 | 1C1G | 1C2G |
| 关键指标 | IP 质量、带宽 | 能直连 Anthropic API |
| 推荐服务商 | 腾讯云轻量、Vultr | Oracle Cloud 免费、AWS |
| 推荐协议/工具 | VLESS + REALITY | Claude Code + CloudCLI UI |
| 月均成本 | ¥20–60 | 免费（Oracle）~ $6（Vultr） |

两个需求不冲突，可以一台服务器同时跑——但如果要跑 Claude Code，就得选境外服务器，然后代理也一起在上面跑。如果只需要代理，一台最低配的新加坡 VPS 完全够用，没必要多花钱。

---

*本文基于实际使用经验整理，协议和工具持续迭代中，具体版本以官方文档为准。*
