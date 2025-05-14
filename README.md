# 🎀 Nginx守护小助手使用指南

> ✨ 一个日志分析+防护脚本，24小时守护你的Web服务器~
> 技术栈：Awk + Bash + crontab + Fail2Ban(可选)

---

## 🛠️ 功能特点
- **日志分析**：自动统计TOP10访问IP 🕵️‍♀️
- **智能防护**：Fail2Ban动态封禁恶意IP 🚫
- **流量控制**：Nginx原生限流配置 ⚡
- **可爱预警**：使用颜文字区分威胁等级 (◕‿◕✿)

---

## 🧸 快速部署

### 1. 安装依赖小工具
```bash
# CentOS 
sudo yum install fail2ban -y

# Ubuntu 
sudo apt install fail2ban -y
```
2. 放置分析脚本
```bash
sudo curl -o /usr/local/bin/nginx_guardian.sh \
https://raw.githubusercontent.com/yourname/cute-nginx-guard/main/nginx_guardian.sh
sudo chmod +x /usr/local/bin/awk_nginxlog.sh
```
3. 添加定时任务
crontab -e
```bash
0 0 * * * /bin/bash /usr/local/bin/awk_nginxlog.sh
```

---

🌈 配置文件说明
🎀 Fail2Ban配置 (/etc/fail2ban/jail.d/nginx.conf)
```bash
[nginx-bad-boys]
enabled = true
filter = nginx-limit-req
action = iptables-multiport[name=nginx, port="80,443", protocol=tcp]
logpath = /var/log/nginx/access.log
maxretry = 100  # 允许试探100次~
findtime = 600  # 10分钟内的记录
bantime = 3600  # 关小黑屋1小时
ignoreip = 127.0.0.1 192.168.1.0/24  # 白名单
```
� Nginx限流配置
```bash
http {
    limit_req_zone $binary_remote_addr zone=cutelimit:10m rate=10r/s;  # 每秒10次请求
    
    server {
        location / {
            limit_req zone=cutelimit burst=20 nodelay;  # 允许撒娇突发20次
            # 其他的配置...
        }
    }
}
```
---

📊 日志分析示例
```bash
# 今日TOP10可疑IP (带颜色高亮~)
cat /var/log/nginx/top_ips.log | \
awk '{printf "\033[35m%-15s\033[0m \033[36m%s次\033[0m", $1,$2; print($2>100?"😱":($2>50?"🤔":"😊")}'
```
输出效果：
```bash
192.168.1.1    258次 😱
114.214.121.3  87次 🤔
127.0.0.1      12次 😊
```
---

🎀 文件结构说明
.
├── nginx_guardian.sh     # 主脚本
├── banned_ips.log        # 被封禁的坏孩子
├── top_ips.log           # TOP10访问IP
└── /etc/fail2ban/        # 防护规则配置

---

📜 更新日志
    v1.1
    🎀 新增Fail2Ban集成
    🐾 优化报警系统

    v1.0
    🍰 初始版本发布

GitHub Stars
