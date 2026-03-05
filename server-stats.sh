#!/bin/bash

# --- Helper Functions ---
print_header() {
    echo -e "\n========================================"
    echo -e "  $1"
    echo -e "========================================\n"
}

# --- Server Information (Stretch Goal) ---
print_header "System Overview"
echo "OS Version:     $(cat /etc/os-release | grep -w "PRETTY_NAME" | cut -d= -f2 | tr -d '"')"
echo "Uptime:         $(uptime -p)"
echo "Load Average:   $(cat /proc/loadavg | awk '{print $1, $2, $3}')"
echo "Logged in Users: $(who | wc -l)"

# --- CPU Usage ---
# Calculates CPU usage by subtracting idle time from 100
print_header "CPU Usage"
cpu_idle=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}')
cpu_usage=$(echo "100 - $cpu_idle" | bc)
echo "Total CPU Usage: ${cpu_usage}%"

# --- Memory Usage ---
print_header "Memory Usage"
free -m | awk 'NR==2{printf "Used: %sMB | Free: %sMB | Usage: %.2f%%\n", $3, $4, $3*100/$2}'

# --- Disk Usage ---
print_header "Disk Usage"
df -h --total | grep 'total' | awk '{printf "Used: %s | Free: %s | Usage: %s\n", $3, $4, $5}'

# --- Top 5 Processes by CPU ---
print_header "Top 5 Processes by CPU Usage"
ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head -n 6

# --- Top 5 Processes by Memory ---
print_header "Top 5 Processes by Memory Usage"
ps -eo pid,ppid,cmd,%mem --sort=-%mem | head -n 6

# --- Security (Stretch Goal) ---
print_header "Security Stats"
failed_logins=$(journalctl _SYSTEMD_UNIT=ssh.service | grep "Failed password" | wc -l)
echo "Failed SSH Login Attempts: $failed_logins"