#!/usr/bin/expect -f

set timeout -1
spawn sudo mysql_secure_installation
expect "Enter password for user root:"
send -- "root\r"
expect "Press y|Y for Yes, any other key for No:"
send -- "no\r"
expect "Change the password for root ? ((Press y|Y for Yes, any other key for No) :"
send -- "no\r"
expect "Remove anonymous users? (Press y|Y for Yes, any other key for No) :"
send -- "yes\r"
expect "Disallow root login remotely? (Press y|Y for Yes, any other key for No) :"
send -- "yes\r"
expect "Remove test database and access to it? (Press y|Y for Yes, any other key for No) :"
send -- "yes\r"
expect "Reload privilege tables now? (Press y|Y for Yes, any other key for No) :"
send -- "yes\r"
expect eof
