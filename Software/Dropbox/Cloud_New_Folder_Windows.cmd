@echo off

SET VAR_YEAR=%DATE:~6,4%
SET VAR_MONTH=%DATE:~3,2%
SET VAR_DAY=%DATE:~0,2%
SET VAR_DATE=%VAR_YEAR%-%VAR_MONTH%-%VAR_DAY%
mkdir "%VAR_DATE% New_Folder"
cd "%VAR_DATE% New_Folder"

echo "1" > "0 user1 [%VAR_DATE%]"
echo "1" > "0 user2 [%VAR_DATE%]"
echo "1" > "0 user3 [%VAR_DATE%]"
