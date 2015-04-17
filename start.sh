#!/bin/bash
set -e

LOGIN_USER=${LOGIN_USER:-}

if [ -z "${LOGIN_USER}" ]; then
	echo "ERROR: "
	exit 1
fi

# ログインするユーザを設定する
# 本設定は一時的であり、コンテナを破棄すれば同時に破棄される
CHECK_USER=`echo ${LOGIN_USER} | cut -d: -f1`
if [ `grep "^${CHECK_USER}:" /etc/passwd | wc -l` -eq 0 ]; then
	useradd -s /bin/bash -m ${CHECK_USER}
fi

echo ${LOGIN_USER} | chpasswd

# sshdを起動する
exec /usr/sbin/sshd -D
