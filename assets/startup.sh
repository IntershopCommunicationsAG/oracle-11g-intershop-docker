#!/bin/bash

monitor() {
    tail -F -n 0 $1 | while read line; do echo -e "$2: $line"; done
}

LISTENER_ORA=/u01/app/oracle/product/11.2.0/xe/network/admin/listener.ora
TNSNAMES_ORA=/u01/app/oracle/product/11.2.0/xe/network/admin/tnsnames.ora

ORACLE_BASE=/u01/app/oracle
ALERT_LOG="$ORACLE_BASE/diag/rdbms/xe/XE/trace/alert_XE.log"
LISTENER_LOG="$ORACLE_BASE/diag/tnslsnr/$HOSTNAME/listener/trace/listener.log"

cp "${LISTENER_ORA}.tmpl" "$LISTENER_ORA" && 
sed -i "s/%hostname%/$HOSTNAME/g" "${LISTENER_ORA}" && 
sed -i "s/%port%/1521/g" "${LISTENER_ORA}" && 
cp "${TNSNAMES_ORA}.tmpl" "$TNSNAMES_ORA" &&
sed -i "s/%hostname%/$HOSTNAME/g" "${TNSNAMES_ORA}" &&
sed -i "s/%port%/1521/g" "${TNSNAMES_ORA}" &&

service oracle-xe start &&

monitor $ALERT_LOG