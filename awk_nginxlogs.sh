#!/bin/bash
# 📜 License: MIT
# 🐱 Author: Rancade
# 🌸 用法: 此脚本仅供参考，请根据实际情况修改脚本内容。
# 脚本名称: awk_nginxlogs.sh
# 功能: 分析Nginx访问日志并统计前10个访问次数最多的IP
# 用法: 使用croantab进行自动化定时执行，每天执行一次。
# 分析Nginx访问日志并统计前10个访问次数最多的IP，并定时自动封禁高频 IP。

log_file="/var/log/nginx/access.log"
output_file="top_ips.log"
threshold=100  # 封禁阈值

# 分析日志并输出前 10 IP
echo "----- Top 10 IPs 访问统计 $(date) -----" > "$output_file"
awk '{print $1}' "$log_file" | sort | uniq -c | sort -nr | head -10 >> "$output_file"

# 自动封禁高频 IP
while read -r count ip; do
  if [ "$count" -gt "$threshold" ]; then
    if ! iptables -C INPUT -s "$ip" -j DROP 2>/dev/null; then
      iptables -A INPUT -s "$ip" -j DROP
      echo "已封禁 IP: $ip (访问次数: $count)" >> banned_ips.log
    fi
  fi
done < <(awk '{print $1}' "$log_file" | sort | uniq -c | sort -nr | head -10)

echo "分析完成，结果已保存到 $output_file"
