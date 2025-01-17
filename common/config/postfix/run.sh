#!/bin/bash

[ "${DEBUG}" == "yes" ] && set -x

function add_config_value() {
  local key=${1}
  local value=${2}
  local config_file=${3:-/etc/postfix/main.cf}
  [ "${key}" == "" ] && echo "ERROR: No key set !!" && exit 1
#  [ "${value}" == "" ] && echo "ERROR: No value set !!" && exit 1

  echo "Setting configuration option ${key} with value: ${value}"
 postconf -e "${key} = ${value}"
}

[ -z "${SERVER_HOSTNAME}" ] && echo "SERVER_HOSTNAME is not set" && exit 1

SMTP_PORT="${SMTP_PORT-587}"

#Get the domain from the server host name
#DOMAIN=`echo ${SERVER_HOSTNAME} |awk -F. '{$1="";OFS="." ; print $0}' | sed 's/^.//'`

# Set needed config options
add_config_value "myhostname" ${SERVER_HOSTNAME}
add_config_value "mydomain" ${DOMAIN}
add_config_value "mydestination" '$myhostname, localhost.$mydomain, localhost'
add_config_value "myorigin" '$mydomain'
add_config_value "mynetworks" ${MYNETWORKS}
add_config_value "home_mailbox" "Maildir/"
add_config_value "local_recipient_maps" ""
add_config_value "luser_relay" "root@${SERVER_HOSTNAME}"

if [ "${ENABLE_MAILPIT}" = "true" ]; then
  add_config_value "relayhost" "[${SMTP_SERVER}]:${SMTP_PORT}"
elif [ -n "${SMTP_SERVER}" ]; then
  add_config_value "relayhost" "[${SMTP_SERVER}]:${SMTP_PORT}"
  add_config_value "smtp_use_tls" "yes"
  add_config_value "smtp_sasl_auth_enable" "yes"
  add_config_value "smtp_sasl_password_maps" "hash:/etc/postfix/sasl_passwd"
  add_config_value "smtp_sasl_security_options" "noanonymous"
fi

# Create sasl_passwd file with auth credentials
if [ -n "${SMTP_SERVER}" ] && [ ! -f /etc/postfix/sasl_passwd ]; then
  grep -q "${SMTP_SERVER}" /etc/postfix/sasl_passwd  > /dev/null 2>&1
  if [ $? -gt 0 ]; then
    echo "Adding SASL authentication configuration"
    echo "[${SMTP_SERVER}]:${SMTP_PORT} ${SMTP_USERNAME}:${SMTP_PASSWORD}" >> /etc/postfix/sasl_passwd
    postmap /etc/postfix/sasl_passwd
  fi
fi

#Set header tag  
if [ ! -z "${SMTP_HEADER_TAG}" ]; then
  postconf -e "header_checks = regexp:/etc/postfix/header_tag"
  echo -e "/^MIME-Version:/i PREPEND RelayTag: $SMTP_HEADER_TAG\n/^Content-Transfer-Encoding:/i PREPEND RelayTag: $SMTP_HEADER_TAG" > /etc/postfix/header_tag
  echo "Setting configuration option SMTP_HEADER_TAG with value: ${SMTP_HEADER_TAG}"
fi

#Start services
supervisord
