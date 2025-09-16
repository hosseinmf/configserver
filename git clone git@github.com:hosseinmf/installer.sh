#!/bin/bash
# ConfigServer Auto Installer/Uninstaller
# GPL v3
# github.com/hosseinmf/configserver

set -e

GREEN="\e[32m"; RED="\e[31m"; NC="\e[0m"
echo -e "${GREEN}*** ConfigServer Installer ***${NC}"

echo "کنترل پنل را انتخاب کنید:"
echo "1) cpanel"
echo "2) cwp"
echo "3) cyberpanel"
echo "4) directadmin"
echo "5) interworx"
echo "6) generic"
echo "7) vesta"
read -rp "شماره گزینه: " CP_OPT

case $CP_OPT in
  1) CP="cpanel" ;;
  2) CP="cwp" ;;
  3) CP="cyberpanel" ;;
  4) CP="directadmin" ;;
  5) CP="interworx" ;;
  6) CP="generic" ;;
  7) CP="vesta" ;;
  *) echo -e "${RED}گزینه نامعتبر${NC}"; exit 1 ;;
esac

echo "محصول مورد نظر:"
echo "1) cmc"
echo "2) cmm"
echo "3) cmq"
echo "4) cse"
echo "5) csf"
read -rp "شماره گزینه: " PROD_OPT

case $PROD_OPT in
  1) PROD="cmc" ;;
  2) PROD="cmm" ;;
  3) PROD="cmq" ;;
  4) PROD="cse" ;;
  5) PROD="csf" ;;
  *) echo -e "${RED}گزینه نامعتبر${NC}"; exit 1 ;;
esac

read -rp "install یا uninstall ? [i/u]: " ACTION
if [[ "$ACTION" == "i" ]]; then
    MODE="install"
elif [[ "$ACTION" == "u" ]]; then
    MODE="uninstall"
else
    echo -e "${RED}گزینه نامعتبر${NC}"
    exit 1
fi

TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

TGZ_URL="https://github.com/waytotheweb/scripts/blob/main/${PROD}.tgz?raw=true"
echo -e "${GREEN}دانلود ${PROD} ...${NC}"
curl -L -o "${PROD}.tgz" "$TGZ_URL"

tar xzf "${PROD}.tgz"
cd "$PROD"

if [[ "$MODE" == "install" ]]; then
    SCRIPT="install.${CP}.sh"
else
    if [[ "$CP" == "vesta" ]]; then
        SCRIPT="uninstall.vesta.sh"
    else
        SCRIPT="uninstall.${CP}.sh"
    fi
fi

if [[ ! -f "$SCRIPT" ]]; then
    echo -e "${RED}اسکریپت $SCRIPT پیدا نشد${NC}"
    exit 1
fi

chmod +x "$SCRIPT"
echo -e "${GREEN}اجرای $SCRIPT ...${NC}"
sudo ./"$SCRIPT"

echo -e "${GREEN}پایان عملیات.${NC}"
