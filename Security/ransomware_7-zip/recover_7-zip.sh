#!/bin/bash

# sudo apt install rhash p7zip-full
# ./1-copy-found; ./2-redater; ./4-remove-7z

# ./1-copy-found; ./2-redater; ./3-not-crypted; ./4-remove-7z; ./5-remove-processed

# Original Q-Recover Version: 0.80
# https://www.ikarussecurity.com/en/security-news-en/qlocker/

# See @todo Windows fuck
# @todo mktemp and remove for: test1, require, duplicstemp
# @todo require: '/mnt/c/Users/file.xml.7z' 5290 AE5BE1EA

createDirectoryIfNotExists() {
  if [ ! -d "${2}" ]; then
    printf "Create %s directory: %s \n" "${1}" "${2}"
    mkdir -p "${2}"
  fi
}

generateChecksums() {
  isUniqueChecksums=0
  if [ -f "checksums.crc32" ]; then
    read -p 'Recalculate Checksums? [y/N] ' -n 1 -r
    echo
  fi
  if [ ! -f "checksums.crc32" ] || [[ $REPLY =~ ^[Yy]$ ]]; then
    printf "Generate checksums...\n"
    rhash -r -p "%p %s %C\n" "$PhotoRec" > checksums.crc32
    isUniqueChecksums=1
  fi
  unset $REPLY

  if [ "${isUniqueChecksums}" -eq "0" ] && [ -f "uniques.crc32" ]; then
    read -p 'ReUnique Checksums? [y/N] ' -n 1 -r
    echo
  fi
  if [ "${isUniqueChecksums}" -eq "1" ] || [ ! -f "uniques.crc32" ] || [[ $REPLY =~ ^[Yy]$ ]]; then
    printf "Unique checksums...\n"
    cat checksums.crc32 | sort -k2,3 | uniq -f1 > uniques.crc32
  fi
  unset $REPLY
}

createRestoreFile() {
  echo "#!/bin/bash" > ${1}
  printf "echo \"%s\"\n" "${2}" >> ${1}
  echo "date" >> ${1}
  # @todo Windows fuck
  #chmod +x ${1}
}

walkDirectory() {
  shopt -s nullglob dotglob

  for pathname in "$1"/*; do
    if [ -d "$pathname" ]; then
      printf "* %s\n" "$pathname"
      walkDirectory "$pathname"
    else
      part1=`dirname "$pathname"`
      part2=`basename "$pathname"`
      part0=${part1/$Encrypted/$Restored}

      case "$pathname" in
        *.7z)
          7za l -slt "$pathname" | tail -12 > test1

          while IFS=' = ' read -r key value; do
            case $key in
              "CRC")
                zcrc32="$value"
              ;;
              "Size")
                zorig="$value"
              ;;
              "Path")
                zname="$value"
              ;;
              "Modified")
                zdate="$value"
              ;;
            esac
          done < test1

          destination="$part0/$zname"

          found=$(grep " $zorig $zcrc32" uniques.crc32 | cut -d" " -f1)
          anz=$(grep -c " $zorig $zcrc32" uniques.crc32)
          ((Total++))

          printf "%s %s %s\n" "${pathname@Q}" "$zorig" "$zcrc32" >> require

          if [[ $anz -eq 1 ]]; then
            printf "cp %s %s\n" "${found@Q}" "${destination@Q}" >> 1-copy-found
            printf "sudo touch %s -d '%s'\n" "${destination@Q}" "$zdate">> 2-redater
            printf "rm %s\n" "${pathname@Q}" >> 4-remove-7z
            ((Anzahl++))
            
            grep " $zorig $zcrc32" checksums.crc32 | cut -d" " -f1  | while read -r line ; do
              printf "rm %s\n" "${line@Q}" >> duplicstemp
            done
          else
            printf "%u;%s;%s;%s\n" "$Anz" "${destination@Q}" "$zorig" "$zdate" >> notfound.csv
          fi

          OldPercent=$((Percent))
          Percent=$(($Total*10/$TotalFind))
          if [[ $OldPercent -ne $Percent ]]; then
            printf "%s0%% . " $Percent
            printf "echo \"%s0%% \"\n" $Percent >> 1-copy-found
            printf "echo \"%s0%% \"\n" $Percent >> 2-redater
            printf "echo \"%s0%% \"\n" $Percent >> 4-remove-7z
          fi
        ;;

        *)
          destination="$part0/$part2"
          ((Unenc++))
          printf "mv %s %s\n" "${pathname@Q}" "${destination@Q}" >> 3-not-crypted
          OldUPercent=$((UPercent))
          if [[ $TotalUnencrypted -ne 0 ]]; then
            UPercent=$(($Unenc*10/$TotalUnencrypted))
            if [[ $OldUPercent -ne $UPercent ]]; then
              printf "echo \"%s0%% \"\n" $UPercent >> 3-not-crypted
            fi
          fi
        ;;
      esac
    fi
  done
}

StartDir=$(pwd)
#PhotoRec="${StartDir}/input"
PhotoRec="/mnt/e/cyb-recover/"
Encrypted="${StartDir}/encrypted"
Restored="${StartDir}/output"

createDirectoryIfNotExists 'input' "${PhotoRec}"
createDirectoryIfNotExists 'encrypted' "${Encrypted}"
createDirectoryIfNotExists 'output' "${Restored}"

echo "Script start: $(date '+%Y-%m-%d %H:%M:%S')"
printf "\n"

Anzahl=0
Total=0
Unenc=0
Percent=0
UPercent=0

TotalUnencrypted=$(find "$Encrypted" -type f | wc -l)
printf "Total Files on Encrypted = %s\n" $TotalUnencrypted
TotalFind=$(find "$Encrypted" -type f -name "*7z" | wc -l)
printf "Total crypted .7z Count = %s\n" $TotalFind
TotalUnencrypted=$(($TotalUnencrypted-$TotalFind))
printf "Total unencrypted Count = %s\n\n" $TotalUnencrypted

generateChecksums

printf "Making Directory Structure...\n"
cd "$Encrypted"
printf "Directory Count = "
find . -type d -printf '.' | wc -c
find . -type d -exec mkdir -p -- "$Restored"/{} \;
printf "Directories created\n\n"

cd "$StartDir"

printf "Creating files...\n"
createRestoreFile '1-copy-found' 'Copying and renaming files...'
createRestoreFile '2-redater' 'Copying file datetime...'
createRestoreFile '3-not-crypted' 'Moving not encrypted files...'
createRestoreFile '4-remove-7z' 'Deleting 7z files from source...'
createRestoreFile '5-remove-processed' 'Deleting duplicate files from PhotoRec...'
echo "" > duplicstemp
echo "# Required Files" > require
echo "Count;Filename;Size;DateTime" > notfound.csv

printf "Search for restored and encrypted files...\n"
walkDirectory "$Encrypted"

if [[ $Total -eq 0 ]]; then
  Total=1
fi

Percent=$(($Anzahl*100/$Total))

echo "date" >> 1-copy-found
printf "echo \"Recovered files: %s of %s (%s%%)\"\necho \"\"\n" $Anzahl $Total $Percent >> 1-copy-found

echo "date" >> 2-redater
printf "echo \"Redated files: %s of %s (%s%%)\"\necho \"\"\n" $Anzahl $Total $Percent >> 2-redater

echo "date" >> 3-not-crypted
printf "echo \"Unencrypted files: %s\"\n\necho \"\"\n" $TotalUnencrypted >> 3-not-crypted

echo "date" >> 4-remove-7z
printf "echo \"Removed files (Encrypted): %s of %s (%s%%)\"\necho \"\"\n" $Anzahl $Total $Percent >> 4-remove-7z

sort duplicstemp | uniq > duplicstemp2
TotalToDelete=$(cat duplicstemp2 | wc -l)
cat duplicstemp2 >> 5-remove-processed
rm duplicstemp
rm duplicstemp2
echo "date" >> 5-remove-processed
printf "echo \"Removed files (PhotoRec): %s \"\necho \"\"\n" $TotalToDelete >> 5-remove-processed

printf "\n"
echo "Script end: $(date '+%Y-%m-%d %H:%M:%S')"

printf "\n\nCreated batch files (call in this order!):\n"
printf "1-copy-found: copy files from PhotoRec to Restored (with matching size+CRC32)\n"
printf "2-redater: changes file datetime in Restored (already processed with 1-copy-found)\n"
printf "3-not-crypted: moves unencrypted files from Encrypted to Restored (not affected by Ransomware)\n"
printf "4-remove-7z: deletes processed 7z in Encrypted (all 7z with matching size+CRC32 PhotoRec file)\n"
printf "5-remove-processed: deletes processed files in PhotoRec (and all with same size+CRC32)\n"
printf "\n"
printf "What remains to be done:\n"
printf "* In PhotoRec: files that were already deleted before Ransomware (maybe old but unencrypted versions)\n"
printf "* In Encrypted: 7z files for which there was no recoverable deleted file (maybe some day we get a decryption tool)\n"
printf "  notfound.csv contains them without ending .7z (plus Count [usually 0], name (UTF-8), size, datetime)\n"
printf "\n"
printf "Recoverable files: %s of %s (%s%%)\n" $Anzahl $Total $Percent
