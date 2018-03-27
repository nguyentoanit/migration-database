#!/bin/bash
#SQL file format: YYYYMMDDHHII_XXXXX.sql
#Set default connection
path="sql"
host="localhost"
database="postgres"
username="postgres"
password=""
type="psql"
port="5432"

#Check flags
while test $# -gt 0; do
    case "$1" in
        -pt|--path)
            shift
            path=$1
            shift
            ;;
        -h|--host)
            shift
            host=$1
            shift
            ;;
        -d|--database)
            shift
            database=$1
            shift
            ;;
        -u|--username)
            shift
            username=$1
            shift
            ;;
        -p|--password)
            shift
            password=$1
            shift
            ;;
        -t|--type)
            shift
            type=$1
            shift
            ;;
        -P|--port)
            shift
            port=$1
            shift
            ;;
    esac
done  

#Go to sql folder
cd $path
ls *.sql > list

#Check file log file
if [ -f "sql.log" ]
then
    value=`cat sql.log`
else
    value=""
fi

# Check type of connection
if [ "$type" == "psql" ]
then
    while read line; do
    if [ "$line" \> "$value" ]
    then
        #Run script from file command
        export PGPASSWORD=$password && psql -h $host -U $username -d $database -p $port -a -f $line
    fi
    done < list
elif [ "$type" == "mysql" ]
then
    while read line; do
    if [ "$line" \> "$value" ]
    then
        #Run script from file command
        mysql -h $host -u $username -D $database -P $port -p$password < $line
    fi
    done < list
fi

tail -n 1 list > sql.log
rm list
