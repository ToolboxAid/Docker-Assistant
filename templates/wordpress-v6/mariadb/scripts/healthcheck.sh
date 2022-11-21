#!/bin/bash

log=/bitnami/mariadb/scripts/alive.log

. /opt/bitnami/scripts/mariadb-env.sh

RESULT=$(mysql -h localhost -P $DB_PORT_NUMBER -u $DB_USER -p$DB_PASSWORD --protocol TCP -se 'select NOW()' )

RC=$?

echo "RESULT: $RESULT * * * RC: $RC">>$log

exit $RC 

