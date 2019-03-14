#!/system/bin/sh
if ! applypatch -c EMMC:/dev/block/bootdevice/by-name/recovery:15205676:e2777cdfe4aca77c1aa52ff3a0d7ec1e61221979; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/bootdevice/by-name/boot:11754792:7dcadfb94b7d106e0edd148330cabf8f68b73304 EMMC:/dev/block/bootdevice/by-name/recovery e2777cdfe4aca77c1aa52ff3a0d7ec1e61221979 15205676 7dcadfb94b7d106e0edd148330cabf8f68b73304:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
