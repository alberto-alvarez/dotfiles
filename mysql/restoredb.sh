#!/bin/bash

# This script will:
#  1. Download MySQL dump files for given database name and backup date
#  2. Drop local database
#  3. Import database to local MySQL
#
# This script expects the CONSTANTS below to be defined..
# It is best if you define then in a super secret ~/.localrc file like this:
source ~/.localrc
# But if you want uncomment and set them below:

# MYSQLUSER="MysqlUserName"
# MYSQLPASS="MysqlPassword"
# EXTERNALIP="IpWhereBackupsAreStored"
# DBBACKUPPATH="FullPathWhereBackupsAreStored"

# We expect backup files to be gunziped and named like dbname-yyyy-mm-dd.sql.gz
# Save today date for convenience
date=`date +%Y-%m-%d`

echo ""
echo "   Database SCP and RESTORE"
echo ""
read -p "   Type the database name to restore: " dbname
echo ""
echo -n "   Use $date to restore the backup? [yes or no]: "
read yno
case $yno in

        [yYsS] | Yes | yes )
                echo "   Using $date to retore the backup"
                ;;

        [nN] | No | no )
                echo -n "   Type a date like $date to restore the backup: "
                read date
                ;;
        *) echo "Invalid input!"
            exit 1
            ;;
esac

uncompressedDumpFile="$USER"_$dbname-$date.sql

# skip download if you already did it recently
# TODO: this should be made a function
if [ $1 == '-nd' ];
then
    if [ ! -f "/tmp/$uncompressedDumpFile" ]
        then
        echo "File /tmp/$uncompressedDumpFile does not exist!"
        exit 1
    fi
    echo "Dropping Database " "$USER"_$dbname
    mysqladmin -u $MYSQLUSER -p$MYSQLPASS -f drop "$USER"_$dbname

    echo "Creating Database " "$USER"_$dbname
    mysqladmin -u $MYSQLUSER -p$MYSQLPASS create "$USER"_$dbname

    echo "    Skipping download and importing to ""$USER""_$dbname ..."
    mysql -u $MYSQLUSER -p$MYSQLPASS "$USER"_$dbname < /tmp/$uncompressedDumpFile
else
    echo "    1. Downloading $dbname-$date.sql.gz to /tmp/"$uncompressedDumpFile.gz
    scp $EXTERNALIP:$DBBACKUPPATH/$dbname-$date.sql.gz /tmp/$uncompressedDumpFile.gz

    echo "    2. Decompressing gz file..."
    gunzip -f /tmp/$uncompressedDumpFile.gz

    echo "    3. Import over ""$USER"_$dbname"?"
    echo ""
    echo "   Press ENTER to proceed! [CTRL+C to cancel]"
    echo "   "
    read ok

    echo "Dropping Database " "$USER"_$dbname
    mysqladmin -u $MYSQLUSER -p$MYSQLPASS -f drop "$USER"_$dbname

    echo "Creating Database " "$USER"_$dbname
    mysqladmin -u $MYSQLUSER -p$MYSQLPASS create "$USER"_$dbname

    echo "    Importing to ""$USER""_$dbname ..."
    mysql -u $MYSQLUSER -p$MYSQLPASS "$USER"_$dbname < /tmp/$uncompressedDumpFile
fi