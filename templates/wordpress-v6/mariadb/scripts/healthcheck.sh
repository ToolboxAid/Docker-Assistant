#!/bin/bash

log=/bitnami/mariadb/scripts/alive.log

. /opt/bitnami/scripts/mariadb-env.sh

RESULT=$(mysql -h localhost -P $DB_PORT_NUMBER -u $DB_USER -p$DB_PASSWORD --protocol TCP -se 'select NOW()' )

RC=$?

echo "RESULT: $RESULT * * * RC: $RC">>$log

exit $RC 

-----------------------------------------------------------------------------------------

log=/bitnami/mariadb/alive.txt

#echo $(date)>>$log

. /opt/bitnami/scripts/mariadb-env.sh


#echo $DB_NAME>>$log
#echo $MARIADB_DATABASE>>$log

#echo $DB_USER>>$log
#echo $DB_PASSWORD>>$log

#echo $DB_ROOT_USER>>$log
#echo $DB_ROOT_PASSWORD>>$log
#echo $DB_MASTER_HOST>>$log
#echo $MARIADB_MASTER_HOST>>$log
#echo $DB_PORT_NUMBER>>$log

# mysqladmin -V

#test=$(mysqladmin -h localhost:$DB_PORT_NUMBER -u $DB_ROOT_USER -p $DB_ROOT_PASSWORD -V)
#
#test=$(mysqladmin -h localhost:$DB_PORT_NUMBER -u $DB_USER -p $DB_PASSWORD -V)
#
RESULT=$(mysql -h localhost -P $DB_PORT_NUMBER -u $DB_USER -p$DB_PASSWORD --protocol TCP -se 'select NOW()' )

RC=$?

echo "RESULT: $RESULT * * * RC: $RC">>$log

#echo "    - RC: $RC">>$log

exit $RC

-----------------------------------------------------------------------------------------


mysqladmin -u root -p'123456' shutdown



mysql -h localhost -u $DB_ROOT_USER -p$DB_ROOT_PASSWORD

 mysql --port=3306 -h localhost -u $DB_ROOT_USER -p$DB_ROOT_PASSWORD

mysql -P 3306 -h localhost -u $DB_ROOT_USER -p$DB_ROOT_PASSWORD










DB_NAME='quizzifies$lepidopterous'
DB_PORT_NUMBER=3306
USER=inyala_scours
DB_PASSWORD='pVomj3cH!_UedMPr4258QTXpMKLd'

myvar=$(mysql -h localhost -P $DB_PORT_NUMBER -u $DB_USER -p$DB_PASSWORD -se 'select NOW()' )
myvar=$(mysql -h localhost -P $DB_PORT_NUMBER -u $DB_USER -p$DB_PASSWORD --protocol TCP -se 'select NOW()' )



mysql -h localhost -u $DB_USER -p$DB_PASSWORD
mysql -h localhost -P $DB_PORT_NUMBER -u $DB_USER -p$DB_PASSWORD

select NOW();
select 1;


quit or exit





myvar=$(mysql mydatabase -u $user -p$password -se "SELECT a, b, c FROM table_a")
