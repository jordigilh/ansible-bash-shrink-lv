#!/bin/bash


disable_lvm_lock(){
    tmpfile=$(/usr/bin/mktemp)
    sed -e 's/\(^[[:space:]]*\)locking_type[[:space:]]*=[[:space:]]*[[:digit:]]/\1locking_type = 1/' /etc/lvm/lvm.conf >"$tmpfile"
    status=$?
    if [[ status -ne 0 ]]; then
     echo "Failed to disable lvm lock: $status" >/dev/kmsg
     exit 1
    fi
    # replace lvm.conf. There is no need to keep a backup since it's an ephemeral file, we are not replacing the original in the initramfs image file
    mv "$tmpfile" /etc/lvm/lvm.conf
}


main() {
    disable_lvm_lock
    /usr/bin/shrink.sh --all --fstab=/etc/fstab.root 1>&2 >/dev/kmsg
}

main "$0"