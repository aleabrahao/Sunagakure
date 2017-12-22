
Hello everyone,

I am providing a script for those who do not have Cisco Prime and measures to automate the backup of Cisco WLC.
In this script I am using expect and may need to install it.
All tests were performed with Debian 9.
I hope it helps you.

#By Alessandro Abrahao
#!/usr/bin/expect

set wlc "WLC-IP"
set username "USER"
set password "PASS"
set tftpip "TFTP_IP"

spawn ssh $wlc

#Including date in filename

set tdate [clock format [clock seconds] -format %Y%m%d]
set newName WLC_BKP_
append newName $tdate
append newName ".txt"


#log_user 0
set timeout 10
expect "(yes/no)?" {
send "yes\r";"r" }
expect "User:"
send -- "$username\r"
expect "Password:"
send -- "$password\r"
expect "Controller"
send -- "transfer upload datatype config\r"
expect "Controller"
send -- "transfer upload filename $newName\r"
expect "Controller"
send -- "transfer upload mode tftp\r"
expect "Controller"
send -- "transfer upload serverip $tftpip\r"
expect "Controller"
send -- "transfer upload start\r"
# some wlc config commands require yes/no verification
expect "(y/N)"
send -- "y\r"
expect "Controller"
send "logout\r"
expect "(y/N)"
send -- "n\r"
expect eof
