#!/bin/bash
echo "* Fetching data from ECB 90-days Exchange rates reference Database (XML)"
ruby CCTconverterApp/lib/downloadXMLfromECB.rb
echo "* New data downloaded"
echo "* Updating ConverterApp Database - This process may take up to 3 minutes"
ruby CCTconverterApp/lib/csv2sqlite.rb CCTconverterApp/lib/ecbs.csv --output CCTconverterApp/db/development.sqlite3
echo "------------------------"

date=$(date +"%m-%d-%Y - %T")
echo $date

echo "** UPDATE COMPLETED ** "

if [ -a update-logs.txt ]
  then echo "Last updated => " $date >> update-logs.txt
else
  touch update-logs.txt
  echo "Last updated => " $date >> update-logs.txt
fi
