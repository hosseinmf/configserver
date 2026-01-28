#!/usr/bin/env bash
# ConfigServer Auto Installer/Uninstaller (fixed for noexec tmp and safer sudo invocation)
# GPL v3
# github.com/hosseinmf/configserver (modified)

set -euo pipefail
IFS=$'\n\t'

echo "*** ConfigServer Installer (fixed) ***"

# Ask for control panel
echo "Select your control panel:"
echo "1) cpanel"
echo "2) cwp"
echo "3) cyberpanel"
echo "4) directadmin"
echo "5) interworx"
echo "6) generic"
echo "7) vesta"
read -r -p "Enter the number of your choice: " CP_OPT

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
read -r -p "Enter the number of your choice: " PROD_OPT

case $PROD_OPT in
  1) PROD="cmc" ;;
  2) PROD="cmm" ;;
  3) PROD="cmq" ;;
  4) PROD="cse" ;;
  5) PROD="csf" ;;
  *) echo "Invalid option"; exit 1 ;;
esac

# Install or uninstall
read -r -p "Do you want to install or uninstall? [i/u]: " ACTION
if [[ "$ACTION" == "i" ]]; then
    MODE="install"
elif [[ "$ACTION" == "u" ]]; then
    MODE="uninstall"
else
    echo "Invalid option"
    exit 1
fi

# create temp dir (in current filesystem) and ensure cleanup
TMP_DIR=$(mktemp -d 2>/dev/null || python -c "import tempfile,sys;print(tempfile.mkdtemp())")
trap 'rm -rf "$TMP_DIR"' EXIT
cd "$TMP_DIR"

# helper to detect noexec on mount point
is_noexec() {
  local dir="$1"
  # find the mount point
  local mp
  mp=$(findmnt -n -o TARGET --target "$dir" 2>/dev/null || true)
  if [[ -z "$mp" ]]; then
    # fallback: check mount output
    mount | awk '{print $3" "$6}' | while read -r _ m; do
      if [[ "$dir" == "$m"* ]]; then
        mp="$m"; break
      fi
    done
  fi
  if [[ -z "$mp" ]]; then
    return 1
  fi
  # check options
  local opts
  opts=$(findmnt -no OPTIONS --target "$mp" 2>/dev/null || true)
  if [[ "$opts" == *"noexec"* ]]; then
    return 0
  fi
  return 1
}

execute_script_with_sudo() {
  local script_path="$1"
  # Prefer invoking bash explicitly under sudo to avoid noexec issues
  if command -v bash >/dev/null 2>&1; then
    sudo bash "$script_path"
  else
    sudo /bin/sh "$script_path"
  fi
}

if [[ "$MODE" == "install" ]]; then
    TGZ_URL="https://raw.githubusercontent.com/wnpower/waytotheweb-scripts/main/${PROD}.tgz"
    echo "Downloading ${PROD} ..."
    curl -L -o "${PROD}.tgz" "$TGZ_URL"
    tar xzf "${PROD}.tgz"
    cd "$PROD"

    if [[ "$PROD" == "csf" ]]; then
        SCRIPT="install.${CP}.sh"
    else
        SCRIPT="install.sh"
    fi

    if [[ ! -f "$SCRIPT" ]]; then
        echo "Install script $SCRIPT not found"
        exit 1
    fi

    # Try to run in-place with sudo bash (works even if tmp is noexec)
    echo "Running $SCRIPT ..."

    # make readable (not strictly required) and try direct sudo bash
    chmod a+r "$SCRIPT" || true

    # If the temp dir is mounted with noexec, copy to a safe location and run there
    if is_noexec "$TMP_DIR"; then
      echo "Notice: $TMP_DIR appears to be mounted with noexec. Copying installer to /usr/local/src and running from there."
      # create target dir as root, copy and set perms
      sudo mkdir -p /usr/local/src/configserver_installer
      sudo cp -a "$SCRIPT" /usr/local/src/configserver_installer/
      # copy any supporting files (e.g. other extracted files) if present
      # copy everything from current extracted $PROD directory
      sudo cp -a . /usr/local/src/configserver_installer/
      TARGET="/usr/local/src/configserver_installer/$SCRIPT"
      execute_script_with_sudo "$TARGET"
    else
      # safe to run in-place
      execute_script_with_sudo "$PWD/$SCRIPT"
    fi

    echo "Installation completed."

else
    # Uninstall
    if [[ "$PROD" == "csf" ]]; then
        URL="https://raw.githubusercontent.com/waytotheweb/scripts/main/uninstallers/csf/uninstall.${CP}.sh"
    else
        URL="https://raw.githubusercontent.com/waytotheweb/scripts/main/uninstallers/${PROD}/${PROD}_uninstall.sh"
    fi

    echo "Running uninstall for ${PROD} ..."

    # same technique: fetch to temp and run with bash under sudo
    curl -sL "$URL" -o uninstall.tmp.sh
    chmod a+r uninstall.tmp.sh || true

    if is_noexec "$TMP_DIR"; then
      echo "Notice: $TMP_DIR appears to be mounted with noexec. Running uninstaller via sudo bash without relying on execute bit."
      sudo bash uninstall.tmp.sh
    else
      sudo bash uninstall.tmp.sh
    fi

    echo "Uninstallation completed."
fi
