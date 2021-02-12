#!/bin/bash

/etc/init.d/oracle-xe configure responseFile=/assets/xe.rsp

echo 'export ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe' >> /etc/bash.bashrc
echo 'export PATH=$ORACLE_HOME/bin:$PATH' >> /etc/bash.bashrc
echo 'export ORACLE_SID=XE' >> /etc/bash.bashrc

source /u01/app/oracle/product/11.2.0/xe/bin/oracle_env.sh
sqlplus -s system/intershop <<< "EXEC DBMS_XDB.SETLISTENERLOCALACCESS(FALSE);"

# Disable Oracle password expiration
export ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe
export PATH=$ORACLE_HOME/bin:$PATH
export ORACLE_SID=XE

. /assets/prepare_db.sh
. /assets/prepare_tablespaces.sh
. /assets/prepare_user.sh
. /assets/prepare_user_2.sh
. /assets/restart_db.sh
