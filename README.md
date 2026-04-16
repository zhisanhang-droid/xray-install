# 科学上网自建节点教程

> 适合人群：有基础动手能力，想自己搭节点、不依赖机场的人。
> 技术方案：Xray + VLESS + Reality（目前主流方案，稳定性和抗封锁能力最强）

---

## 一、需要买什么服务器

### 服务器要求

- **位置**：必须在境外（推荐新加坡、日本、美国西海岸）
- **配置**：自用 1核1G 够用；带 3-5 人 1核2G 足矣
- **带宽**：最低 20Mbps，推荐 100Mbps+（看视频流畅的关键）
- **系统**：Ubuntu 22.04（推荐）或 Debian 12

### 推荐服务商对比

| 服务商 | 价格 | 优点 | 适合人群 |
|--------|------|------|----------|
| **Vultr** | $6/月起 | 按小时计费、随时删除、新加坡/日本节点多 | 首选，灵活 |
| **RackNerd** | $15/年起 | 极便宜，年付性价比高 | 预算有限 |
| **腾讯云轻量** | ¥24/月 | 中文界面、支付宝付款、新加坡节点 | 不习惯英文界面 |
| **搬瓦工 BandwagonHost** | $50/年起 | 线路优化好、CN2 GIA | 速度要求高 |

> **新手推荐 Vultr**：注册简单、支持支付宝/微信、最低 $6/月、不用就删掉不浪费钱。

### Vultr 购买步骤（简版）

1. 打开 vultr.com → 注册账号（邮箱+密码）
2. Billing → 充值（支付宝/微信/信用卡均可），充 $10 够用两个月
3. Products → Deploy Server → 选择：
   - **Type**: Cloud Compute - Shared CPU
   - **Location**: Singapore 或 Tokyo
   - **OS**: Ubuntu 22.04 LTS
   - **Plan**: $6/月（1核1G 25G SSD）
4. 点 Deploy → 等 2 分钟 → 看到 IP 地址说明开好了

---

## 二、连接服务器

买好后，服务商会给你一个 **IP 地址 + root 密码**。

### Mac / Linux 连接方式

打开终端，输入：

```bash
ssh root@你的服务器IP
```

提示输入密码，粘贴进去（输入时不显示，正常），回车。

### Windows 连接方式

下载 **FinalShell** 或 **MobaXterm**（免费），新建连接填入 IP 和密码即可。

---

## 三、一键安装（核心步骤）

连上服务器后，**复制下面这段命令，粘贴回车**，等待自动完成：

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/zhisanhang-droid/xray-install/main/install.sh)
```

安装完成后，终端会输出类似这样的内容：

```
========================================
        Xray Reality 连接信息
========================================
服务器 IP   : 1.2.3.4
端口        : 8443
UUID        : xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
公钥 (pbk)  : xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
ShortID     : xxxxxxxxxxxxxxxx

VLESS 链接（复制到客户端导入）：
vless://xxxxxx@1.2.3.4:8443?...#MyProxy
========================================
```

**把那行 `vless://` 开头的链接复制保存好**，客户端需要用它。

---

## 四、客户端配置

### iPhone / iPad

1. App Store 搜索 **Shadowrocket**（小火箭），购买下载（¥18，一次买永久用）
2. 打开 App → 右上角 `+` → 选"扫描二维码"或"从剪贴板导入"
3. 把 vless:// 链接复制后，点"从剪贴板导入"
4. 回到首页，点击节点旁边开关 → 顶部总开关打开

### Android

1. 下载 **v2rayNG**（GitHub 或 APKPure 搜索）
2. 打开 → 右上角 `+` → 从剪贴板导入
3. 粘贴 vless:// 链接 → 保存
4. 点击纸飞机图标启动

### Windows

1. 下载 **v2rayN**（GitHub：2dust/v2rayN，下载 v2rayN-with-core.zip）
2. 解压运行 → 服务器 → 从剪贴板导入批量 URL
3. 选中节点右键 → 设为活动服务器
4. 右下角托盘图标 → 开启系统代理

### Mac

1. 下载 **V2rayU**（GitHub：yanue/V2rayU）
2. 安装后菜单栏出现图标 → 右键 → 从剪贴板导入
3. 粘贴 vless:// 链接 → 保存 → 打开 V2rayU

---

## 五、验证是否成功

客户端连上后，打开浏览器访问：

- [google.com](https://www.google.com) — 能打开说明成功
- [speed.cloudflare.com](https://speed.cloudflare.com) — 测速，看实际带宽

---

## 六、日常维护命令

连上服务器后，常用命令：

```bash
# 查看服务状态
docker ps

# 查看运行日志
docker logs xray

# 重启服务
cd /opt/xray && docker compose restart

# 停止服务
cd /opt/xray && docker compose down

# 查看连接信息（忘记链接时用）
cat /opt/xray/client-info.txt

# 更新 Xray 到最新版
cd /opt/xray && docker compose pull && docker compose up -d
```

---

## 七、常见问题

**Q：装完连不上，怎么排查？**

1. 先确认服务在跑：`docker ps | grep xray`（应该显示 Up）
2. 检查端口是否开放：`ss -tlnp | grep 8443`
3. 云服务商控制台检查安全组/防火墙是否放行了 8443 端口（腾讯云、阿里云需要手动添加入站规则）

**Q：速度慢怎么办？**

- 换个更近的服务器节点（新加坡 > 日本 > 美国）
- 检查服务器带宽配置
- 客户端开启"分流模式"（国内网站直连，国外走代理）

**Q：IP 被封了怎么办？**

- 腾讯云/Vultr 可以更换 IP（部分服务商免费换，部分收费）
- 换完 IP 后重新运行安装脚本，会自动生成新的连接信息
- 预防方案：用 Cloudflare CDN 套一层（进阶，暂不展开）

**Q：安全吗？会暴露我的身份吗？**

- VLESS Reality 协议伪装成正常 HTTPS 流量，外部看不出来是代理
- 连接是加密的，运营商看不到你访问的内容
- 正常个人使用风险极低

---

## 八、费用总结

| 项目 | 费用 |
|------|------|
| 服务器（Vultr 新加坡 1G） | $6/月 ≈ ¥44 |
| 客户端 Shadowrocket（iOS） | ¥18 一次性 |
| Android/Windows/Mac 客户端 | 免费 |
| **合计** | **约 ¥44/月** |

相比机场（¥30-100/月），价格差不多，但**完全自己掌控，不存在跑路风险**。

---

*本教程基于 Xray 26.x + VLESS Reality 协议，截至 2026 年仍为主流方案。*
