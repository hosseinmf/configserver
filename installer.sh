#!/bin/bash
# ConfigServer Auto Installer/Uninstaller
# GPL v3
# github.com/hosseinmf/configserver

set -e

echo "*** ConfigServer Installer ***"

# Ask for control panel
echo "Select your control panel:"
echo "1) cpanel"
echo "2) cwp"
echo "3) cyberpanel"
echo "4) directadmin"
echo "5) interworx"
echo "6) generic"
echo "7) vesta"
read -rp "Enter the number of your choice: " CP_OPT

case $CP_OPT in
  1) CP="cpanel" ;;
  2) CP="cwp" ;;
  3) CP="cyberpanel" ;;
  4) CP="directadmin" ;;
  5) CP="interworx" ;;
  6) CP="generic" ;;
  7) CP="vesta" ;;
  *) echo "Invalid option"; exit 1 ;;
esac

# Ask for product
echo "Select the ConfigServer product:"
echo "1) cmc"
echo "2) cmm"
echo "3) cmq"
echo "4) cse"
echo "5) csf"
read -rp "Enter the number of your choice: " PROD_OPT

case $PROD_OPT in
  1) PROD="cmc" ;;
  2) PROD="cmm" ;;
  3) PROD="cmq" ;;
  4) PROD="cse" ;;
  5) PROD="csf" ;;
  *) echo "Invalid option"; exit 1 ;;
esac

# Install or uninstall
read -rp "Do you want to install or uninstall? [i/u]: " ACTION
if [[ "$ACTION" == "i" ]]; then
    MODE="install"
elif [[ "$ACTION" == "u" ]]; then
    MODE="uninstall"
else
    echo "Invalid option"
    exit 1
fi

TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

if [[ "$MODE" == "install" ]]; then
    # Download the selected product archive
    TGZ_URL="https://raw.githubusercontent.com/waytotheweb/scripts/main/${PROD}.tgz"
    echo "Downloading ${PROD} ..."
    curl -L -o "${PROD}.tgz" "$TGZ_URL"
    tar xzf "${PROD}.tgz"
    cd "$PROD"

    # Determine the correct install script
    SCRIPT="install.${CP}.sh"
    if [[ ! -f "$SCRIPT" ]]; then
        echo "Install script $SCRIPT not found"
        exit 1
    fi

    chmod +x "$SCRIPT"
    echo "Running $SCRIPT ..."
    sudo ./"$SCRIPT"
    echo "Installation completed."

else
    # Uninstall commands using Raw GitHub URLs for all 5 products
    case "$PROD" in
        cmc)
            echo "Running uninstall for cmc ..."
            curl -sL https://raw.githubusercontent.com/waytotheweb/scripts/main/uninstallers/cmc/cmc_uninstall.sh | bash
            ;;
        cmm)
            echo "Running uninstall for cmm ..."
            curl -sL https://raw.githubusercontent.com/waytotheweb/scripts/main/uninstallers/cmm/cmm_uninstall.sh | bash
            ;;
        cmq)
            echo "Running uninstall for cmq ..."
            curl -sL https://raw.githubusercontent.com/waytotheweb/scripts/main/uninstallers/cmq/cmq_uninstall.sh | bash
            ;;
        cse)
            echo "Running uninstall for cse ..."
            curl -sL https://raw.githubusercontent.com/waytotheweb/scripts/main/uninstallers/cse/cse_uninstall.sh | bash
            ;;
        csf)
            echo "Running uninstall for csf ..."
            curl -sL https://raw.githubusercontent.com/waytotheweb/scripts/main/uninstallers/csf/csf_uninstall.sh | bash
            ;;
        *)
            echo "No uninstall script available for ${PROD}"
            exit 1
            ;;
    esac
    echo "Uninstallation completed."
fi
