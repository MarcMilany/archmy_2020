Chrony

cat <<EOF > /etc/chrony.conf
# Use public NTP servers from the pool.ntp.org project.
server 0.pool.ntp.org offline
server 1.pool.ntp.org offline
server 2.pool.ntp.org offline
server 3.pool.ntp.org offline

# Record the rate at which the system clock gains/losses time.
driftfile /etc/chrony.drift

# In first three updates step the system clock instead of slew
# if the adjustment is larger than 1 second.
makestep 1.0 3

# Enable kernel synchronization of the real-time clock (RTC).
rtcsync

rtconutc
EOF

Chrony work with Network Manager
Постоянная работа с сетевым менеджером

cat << EOF > /etc/NetworkManager/dispatcher.d/10-chrony
#!/bin/sh

INTERFACE=\$1
STATUS=\$2

# Make sure we're always getting the standard response strings
LANG='C'

CHRONY=\$(which chronyc)

chrony_cmd() {
    echo "Chrony going \$1."
    exec \$CHRONY -a \$1
}

nm_connected() {
    [ "\$(nmcli -t --fields STATE g)" = 'connected' ]
}

case "\$STATUS" in
    up)
        chrony_cmd online
    ;;
    vpn-up)
        chrony_cmd online
    ;;
    down)
        # Check for active interface, take offline if none is active
        nm_connected || chrony_cmd offline
    ;;
    vpn-down)
        # Check for active interface, take offline if none is active
        nm_connected || chrony_cmd offline
    ;;
EOF

chmod +x /etc/NetworkManager/dispatcher.d/10-chrony






