{ lib,
  pkgs,
}:

pkgs.writeShellScriptBin "usb_reset" ''
  # see https://unix.stackexchange.com/a/28793/13428
  if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
  fi

  # see https://askubuntu.com/a/290519/1841
  for i in /sys/bus/pci/drivers/[uoex]hci_hcd/*:*; do
    [ -e "$i" ] || continue
    echo "''${i##*/}" > "''${i%/*}/unbind"
    echo "''${i##*/}" > "''${i%/*}/bind"
  done
''
