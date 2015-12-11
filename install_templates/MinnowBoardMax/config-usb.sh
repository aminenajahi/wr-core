######################################################################
# Define some configuration variables

# set this variable 
INITRAMFS_EXTRAS=""

# set artifacts dir to the location of the kernel, image, etc.
if [ -z "${ARTIFACTS_DIR}" ]; then
    ARTIFACTS_DIR=""
fi

INSTALL_KERNEL="${ARTIFACTS_DIR}/bzImage"
INSTALL_ROOTFS="${ARTIFACTS_DIR}/cube-essential-intel-corei7-64.tar.bz2"
INSTALL_MODULES=""
INSTALL_INITRAMFS="${ARTIFACTS_DIR}/cube-builder-initramfs-intel-corei7-64.cpio.gz"
INSTALL_EFIBOOT="${ARTIFACTS_DIR}/bootx64.efi"

INSTALL_GRUBHDCFG="grub-hd.cfg"
INSTALL_GRUBUSBCFG="grub-usb.cfg"
INSTALL_GRUBCFG="${INSTALLER_FILES_DIR}/${INSTALL_GRUBUSBCFG}"

INSTALL_FILES="${INSTALL_KERNEL} ${INSTALL_ROOTFS} ${INSTALL_MODULES} ${INSTALL_GRUBCFG}"

HDINSTALL_ROOTFS="${ARTIFACTS_DIR}/cube-graphical-builder-genericx86-64.tar.bz2 \
                  ${ARTIFACTS_DIR}/cube-builder-genericx86-64.tar.bz2"


# Uncomment to specify path to init.pp
#INSTALL_PUPPET_DIR="puppet"

## List of prerequisite files for the installer to check
PREREQ_FILES="${INSTALL_FILES}"
BOARD_NAME="Generic x86"
EVAL_NAME="Evaluation - OverC"
DISTRIBUTION="Pulsar Linux 7"

BOOTPART_START="63s"
BOOTPART_END="250M"
BOOTPART_FSTYPE="fat32"
BOOTPART_LABEL="boot"

ROOTFS_START="250M"
ROOTFS_END="-1"	# Specify -1 to use the rest of drive
ROOTFS_FSTYPE="ext2"
ROOTFS_LABEL="rootfs"

USBSTORAGE_BANNER="USB Creator for the Hard Drive Installer
--------------------------------------------------------------------------------
$EVAL_NAME
--------------------------------------------------------------------------------"

USBSTORAGE_INTRODUCTION="
This script will erase all data on your USB flash drive and configure it to boot
the Wind River Hard Drive Installer.  This installer will then allow you to
install a working system configuration on to your internal hard drive.
"

INSTALLER_COMPLETE="Installation is now complete"

CONFIRM_INSTALL=1
CONFIRM_REBOOT=0

CMD_GRUB_INSTALL="/usr/sbin/grub-install"

######################################################################
# Define some debug output variables

# Debug Levels - fixed values
DEBUG_SILENT=0
DEBUG_CRIT=1
DEBUG_WARN=2
DEBUG_INFO=4
DEBUG_VERBOSE=7

# Set your default debug level
: ${DEBUG_DEFAULT:=${DEBUG_INFO}}

# Dynamic debug level
DEBUG_LEVEL=${DEBUG_DEFAULT}

: ${TRACE:=0}

CONFIG_FILE_ARM="config-usb-arm.sh"
export X86_ARCH=true
#get the target's architecture, x86 or not x86?
file -L $INSTALL_KERNEL | grep -i x86 >/dev/null 2>&1
if [ $? -ne 0 ]; then
       export X86_ARCH=false
fi

if ! $X86_ARCH; then
	if ! [ -e "$CONFIG_FILE_ARM" ]; then
		echo "ERROR: Could not find confgiration file (${CONFIG_FILE_ARM}) for ARM architecture."
		exit 1
	else
		source $CONFIG_FILE_ARM
	fi
fi
