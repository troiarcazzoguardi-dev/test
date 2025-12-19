#!/usr/bin/env bash
set -e

IFACE=${1:-eth0}

echo "[+] NIC queue tuning for $IFACE"

# Massimizza code TX/RX
sudo ethtool -L $IFACE combined $(nproc)

# Aumenta ring buffer
sudo ethtool -G $IFACE rx 4096 tx 4096 || true

# RSS hash su UDP
sudo ethtool -N $IFACE rx-flow-hash udp4 sdfn || true

echo "[+] CPU governor -> performance"
for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
  echo performance | sudo tee $cpu > /dev/null
done

echo "[+] NUMA auto-balance off"
echo 0 | sudo tee /proc/sys/kernel/numa_balancing

echo "[+] Tuning completed"
