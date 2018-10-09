#!/bin/sh

CREDENTIALS="
user1:hogehoge
user2:fugafuga
"

if [ ! -e /etc/ipsec.d/ ]; then
  mkdir /etc/ipsec.d/
fi

if [ ! -e /etc/ppp/ ]; then
  mkdir /etc/ppp/
fi

cp /dev/null /etc/ppp/chap-secrets
cp /dev/null /etc/ipsec.d/passwd

echo "$CREDENTIALS" | while IFS=: read username password;
do
  if [ -z "$username" -o -z "$password" ]; then
    continue
  fi

  cat >> /etc/ppp/chap-secrets <<EOF
"$username" l2tpd "$password" *
EOF

  vpn_password_enc=$(openssl passwd -1 "$password")
  cat >> /etc/ipsec.d/passwd <<EOF
$username:$vpn_password_enc:xauth-psk
EOF
done

