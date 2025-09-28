#!/usr/bin/env bash

# https://wiki.archlinux.org/title/Systemd-networkd

function setup_network()
{
	log "Setting up network"
	cat <<-README >> ${README}
	## Network
	Wired: systemd-networkd, /etc/systemd/network/wired.network
	DHCP: IPv4
	DNS: systemd-resolved with mdns enabled
	README
    
    touch /etc/systemd/network/wired.network   # Создать файл etc/systemd/network/wired.network
	cat <<-EOF > /mnt/etc/systemd/network/wired.network
	[Match]
	Name=en*
	[Network]
	LinkLocalAddressing=ipv4-fallback
	IPv6AcceptRA=no
	DHCP=ipv4
	MulticastDNS=resolve
	[DHCPv4]
	UseHostname=false
	UseDomains=true
	EOF

	arch-chroot /mnt /bin/bash <<-EOF
	ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
	systemctl enable systemd-networkd
	systemctl enable systemd-resolved
	EOF
}


###################
# Проводной адаптер с использованием DHCP моя
# /etc/systemd/network/20-ethernet.network
touch /etc/systemd/network/20-ethernet.network   # Создать файл etc/systemd/network/20-ethernet.network
cat <<EOF >/etc/systemd/network/20-ethernet.network
[Match]
Name=en*
Name=eth*

[Network]
Address=
Gateway=
DHCP=yes

EOF
###
echo " Запустим службу systemd-networkd "
systemctl enable systemd-networkd
#systemctl status systemd-networkd
##########################################

# Проводной адаптер с использованием DHCP
# /etc/systemd/network/20-wired.network
touch /etc/systemd/network/20-wired.network  # Создать файл /etc/systemd/network/20-wired.network
cat <<EOF >/etc/systemd/network/20-wired.network
[Match]
Name=enp1s0

[Network]
DHCP=yes

EOF
###

# Беспроводной адаптер
# /etc/systemd/network/25-wireless.network
touch /etc/systemd/network/25-wireless.network   # Создать файл /etc/systemd/network/20-wired.network
cat <<EOF >/etc/systemd/network/25-wireless.network
[Match]
Name=wlp2s0

[Network]
DHCP=yes
IgnoreCarrierLoss=3s

EOF
###

# Проводной адаптер, использующий статический IP
# /etc/systemd/network/20-wired.network
touch /etc/systemd/network/20-wired.network  # Создать файл /etc/systemd/network/20-wired.network
cat <<EOF >/etc/systemd/network/20-wired.network
[Match]
Name=enp1s0

[Network]
Address=10.1.10.9/24
Gateway=10.1.10.1
DNS=10.1.10.1

EOF
###

# Проводные и беспроводные адаптеры на одном компьютере
# /etc/systemd/network/20-wired.network
touch /etc/systemd/network/20-wired.network   # Создать файл /etc/systemd/network/20-wired.network
cat <<EOF >/etc/systemd/network/20-wired.network
[Match]
Name=enp1s0

[Network]
DHCP=yes

[DHCPv4]
RouteMetric=100

[IPv6AcceptRA]
RouteMetric=100

EOF
###

# /etc/systemd/network/25-wireless.network
touch /etc/systemd/network/25-wireless.network   # Создать файл /etc/systemd/network/25-wireless.network
cat <<EOF >/etc/systemd/network/25-wireless.network
[Match]
Name=wlp2s0

[Network]
DHCP=yes

[DHCPv4]
RouteMetric=600

[IPv6AcceptRA]
RouteMetric=600

EOF
###

# [DHCP-сервер]
# /etc/systemd/network/ wlan0 .network
touch /etc/systemd/network/ wlan0 .network   # Создать файл /etc/systemd/network/ wlan0 .network
cat <<EOF >/etc/systemd/network/ wlan0 .network
[Match]
Name=wlan0

[Network]
Address=10.1.1.1/24
DHCPServer=true
IPMasquerade=ipv4

[DHCPServer]
PoolOffset=100
PoolSize=20
EmitDNS=yes
DNS=9.9.9.9

EOF
###
