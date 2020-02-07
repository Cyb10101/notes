#!/usr/bin/env bash
set -e

PATH_CERTIFICATE="/root/module-signing"
SIGN_MODULES=(
  evdi
  vboxdrv
)

colorRed='\033[0;31m'
colorGreen='\033[0;32m'
colorYellow='\033[0;33m'
colorReset='\033[0m'

checkUserRoot() {
  if [[ $EUID -ne 0 ]]; then
    echo -e "${colorRed}You must be a root user!${colorReset}"
    exit 1
  fi
}

checkMokUtil() {
  if ! hash mokutil 2>/dev/null; then
    echo -e "${colorRed}[ERROR] MOK utility not installed!${colorReset}"
    echo -e "${colorYellow}Try: apt install mokutil${colorReset}"
    sleep 3;
    exit 1;
  fi
}

checkSecureBootEnabled() {
  SECUREBOOT_STATE=$(mokutil --sb-state | tr '[:upper:]' '[:lower:]' | head -n 1)
  if [ "${SECUREBOOT_STATE}" != "secureboot enabled" ]; then
    echo -e "${colorRed}[ERROR] Secure Boot is currently not enabled:${colorReset}"
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
		echo -e "${colorRed}Can not create folder '${1}'${colorReset}";
		exit 1;
	fi;
}

createCertificateAndImport() {
  # Create signing key and import to MOK
  if [ ! -f "${PATH_CERTIFICATE}/mok.priv" ]; then
    echo -e "${colorYellow}Create new certificate for secure boot modules!${colorReset}"
    openssl req -new -x509 -newkey rsa:2048 -keyout ${PATH_CERTIFICATE}/mok.priv -outform DER -out ${PATH_CERTIFICATE}/mok.der -nodes -days 36500 -subj "/CN=${1}/"

    echo -e "\n${colorYellow}Import MOK: (Use simple password)${colorReset}"
    mokutil --import ${PATH_CERTIFICATE}/mok.der
  else
    echo -e "${colorGreen}[OK] Certificate already exists.${colorReset}"
  fi
}

signModules() {
  echo -e "\n${colorYellow}Sign modules:${colorReset}"
  for module in "${SIGN_MODULES[@]}"; do
    if modinfo -n "${module}" &> /dev/nul; then
        echo -e "${colorGreen}* ${module} ($(modinfo -n ${module}))${colorReset}"
        /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ${PATH_CERTIFICATE}/mok.priv ${PATH_CERTIFICATE}/mok.der $(modinfo -n "${module}")
    else
        echo -e "${colorRed}* ${module} (not found!)${colorReset}"
    fi
  done
}

checkUserRoot
checkMokUtil
checkSecureBootEnabled
createFolder "${PATH_CERTIFICATE}"
createCertificateAndImport "Owner module signing"
signModules

echo -e "\n${colorYellow}Reboot and enroll MOK!${colorReset}"
echo -e "MOK management utility will automatically start."
echo -e "Choose: Enroll MOK"
echo -e "Continue and confirm enrollment"
echo -e "Use the previous password to import the certificate."
