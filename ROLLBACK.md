# Rollback runbook

Recovery procedures for this machine. Written for the specific btrfs layout in
use here — **the generic `snapper rollback` advice you'll find online does not
apply**, see "Why" at the bottom.

## Layout facts you need

| | |
|---|---|
| Device | `/dev/nvme0n1p2` |
| UUID | `c51d729a-1227-408f-b8bd-1818fa277788` |
| Root subvolume | `@` |
| Snapshots subvolume | `@.snapshots`, mounted at `/.snapshots` |
| Snapshot path | `/.snapshots/<N>/snapshot` |
| Bootloader | systemd-boot (no snapshot boot menu) |

`/home` is a **separate subvolume (`@home`) and is not snapshotted**. Rolling
back the root filesystem does not touch your personal files, projects, or
anything under `/home`. It only reverts installed packages and system config.

---

## Level 1 — system still boots, one package broke something

Fastest fix, no USB needed. Most nvidia/kernel breakage lands here: you get a
TTY but no desktop. Switch to a TTY with `Ctrl+Alt+F2`, then downgrade the
offending package from the local cache:

```bash
ls /var/cache/pacman/pkg | grep nvidia-open-dkms
sudo pacman -U /var/cache/pacman/pkg/nvidia-open-dkms-<older-version>.pkg.tar.zst
sudo reboot
```

The paccache timer keeps 2 versions of every package precisely so this works.

To see what a given pacman transaction changed:

```bash
snapper -c root list
snapper -c root status <pre-N>..<post-N>
```

---

## Level 2 — system still boots, want the whole root state back

```bash
snapper -c root list                    # pick the pre-snapshot you want
snapper -c root undochange <N>..0       # revert files to that snapshot's state
```

`undochange` reverts file contents in place rather than swapping subvolumes, so
it works fine with this layout. Reboot afterwards.

---

## Level 3 — system will not boot

Needs an Arch USB. This swaps the broken root subvolume for a snapshot.

```bash
# 1. Boot the Arch ISO, then mount the TOP-LEVEL of the filesystem (subvolid=5),
#    not the root subvolume.
mount -o subvolid=5 /dev/nvme0n1p2 /mnt
ls /mnt                                 # you should see: @ @home @.snapshots @pkg @log

# 2. Find the snapshot you want. info.xml holds the description and timestamp.
ls /mnt/@.snapshots/
cat /mnt/@.snapshots/42/info.xml

# 3. Move the broken root aside — do NOT delete it yet.
mv /mnt/@ /mnt/@.broken

# 4. Create a WRITABLE copy of the snapshot as the new root.
#    (Snapshots are read-only; omitting -r here gives you a writable one.)
btrfs subvolume snapshot /mnt/@.snapshots/42/snapshot /mnt/@

# 5. Reboot.
umount /mnt
reboot
```

Once you have confirmed the system is healthy, reclaim the old root:

```bash
mount -o subvolid=5 /dev/nvme0n1p2 /mnt
btrfs subvolume delete /mnt/@.broken
umount /mnt
```

---

## Why plain `snapper rollback` does not work here

`snapper rollback` works by setting the btrfs *default subvolume* and expecting
the system to boot whatever that points at. On this machine both `/etc/fstab`
and the kernel command line name the subvolume explicitly:

```
fstab:   subvol=/@
cmdline: rootflags=subvol=@
```

An explicit `subvol=` overrides the default subvolume, so the mount would keep
landing on `@` and the rollback would silently have no effect. The manual
subvolume swap in Level 3 is what actually changes what boots.

If you ever want `snapper rollback` to work directly, drop `rootflags=subvol=@`
from the loader entry and change fstab to mount by `subvolid=5` — but the manual
procedure above is fine and involves no boot-critical edits.
