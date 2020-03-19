#!/bin/sh

librcfile="/lib/systemd/system/rc-local.service"
etcrcfile="/etc/systemd/system/rc-local.service"
rcfile="/etc/rc.local"

ln -fs "$librcfile" "$etcrcfile"

cat > "$etcrcfile" <<-EOF
#  This file is part of systemd.
#
#  systemd is free software; you can redistribute it and/or modify it
#  under the terms of the GNU Lesser General Public License as published by
#  the Free Software Foundation; either version 2.1 of the License, or
#  (at your option) any later version.

# This unit gets pulled automatically into multi-user.target by
# systemd-rc-local-generator if /etc/rc.local is executable.
[Unit]
Description=/etc/rc.local Compatibility
ConditionFileIsExecutable=/etc/rc.local
After=network.target

[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
Alias=rc-local.service
EOF

# 这里的-f参数判断$myFile是否存在
if [ ! -f "$rcfile" ]; then
    touch "$rcfile"
	chmod 755 "$rcfile"
    cat > "$rcfile" <<-EOF
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.
 
# bash /root/bindip.sh
 
exit 0
EOF

fi
systemctl enable rc-local
systemctl daemon-reload