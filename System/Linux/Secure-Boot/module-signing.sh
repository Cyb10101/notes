#!/usr/bin/env bash
set -e

textColor() {
  echo -e "\033[0;3${1}m${2}\033[0m"
}

checkUserRoot() {
  if [[ $EUID -ne 0 ]]; then
    textColor 1 "You must be a root user!"
    exit 1
  fi
}

checkMokUtil() {
  if ! hash mokutil 2>/dev/null; then
    textColor 1 "[ERROR] MOK utility not installed!"
    textColor 3 "Try: apt install mokutil"
    sleep 3;
    exit 1;
  fi
}

checkSecureBootEnabled() {
  SECUREBOOT_STATE=$(mokutil --sb-state | tr '[:upper:]' '[:lower:]' | head -n 1)
  if [ "${SECUREBOOT_STATE}" != "secureboot enabled" ]; then
    textColor 1 "[ERROR] Secure Boot is currently not enabled:"
    mokutil --sb-state
    sleep 3;
    exit 1;
  fi
}

createFolder() {
  if [ ! -d "${1}" ]; then
    mkdir -p "${1}";
  fi;
  if [ ! -d "${1}" ]; then
    textColor 1 "Can not create folder '${1}'";
    exit 1;
  fi;
}

createCertificateAndImport() {
  # Create signing key and import to MOK
  if [ ! -f "${PATH_CERTIFICATE}/mok.priv" ]; then
    textColor 3 "Create new certificate for secure boot modules!"
    openssl req -new -x509 -newkey rsa:2048 -keyout ${PATH_CERTIFICATE}/mok.priv -outform DER -out ${PATH_CERTIFICATE}/mok.der -nodes -days 36500 -subj "/CN=${1}/"

    textColor 3 "\nImport MOK: (Use simple password)"
    sudo mokutil --import ${PATH_CERTIFICATE}/mok.der
  else
    textColor 2 "[OK] Certificate already exists."
  fi
}

signModules() {
  textColor 3 "\nSign modules:"
  set +e
  for module in "${SIGN_MODULES[@]}"; do
    if modinfo -n "${module}" &> /dev/null; then
      textColor 2 "* ${module} ($(modinfo -n ${module}))"
      sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ${PATH_CERTIFICATE}/mok.priv ${PATH_CERTIFICATE}/mok.der $(modinfo -n "${module}")
    else
      textColor 1 "* ${module} (not found!)"
    fi
  done
  set -e
}

# Script #######################################################################
PATH_CERTIFICATE="/root/module-signing"
SIGN_MODULES=(
  evdi
  vboxdrv
  vboxnetflt
  vboxnetadp
  vboxpci
)
#tail $(modinfo -n vboxdrv) | grep "Module signature appended"

checkUserRoot
#textColor 3 "Elevate sudo pemissions!"
#sudo echo 'Wonderful...'

checkMokUtil
checkSecureBootEnabled
createFolder "${PATH_CERTIFICATE}"
createCertificateAndImport "Owner module signing"
signModules

echo ''
textColor 3 "Reboot and enroll MOK!"
echo "MOK management utility will automatically start."
echo "Choose: Enroll MOK"
echo "Continue and confirm enrollment"
echo "Use the previous password to import the certificate."
