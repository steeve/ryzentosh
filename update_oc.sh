#!/bin/bash

OPENCORE_VERSION="0.6.8"
OC_BINARY_DATA_VERSION="ccf3d0c36784100293ccfb2865e10cd37f7a78ee"
LILU_VERSION="1.5.2"
VIRTUAL_SMC_VERSION="1.2.2"
WHATEVERGREEN_VERSION="1.4.9"
APPLE_ALC_VERSION="1.5.9"
NVME_FIX_VERSION="1.0.6"


WORKSPACE="${PWD}"
OPENCORE_FILES=(
    "EFI/BOOT/BOOTx64.efi"
    "EFI/OC/OpenCore.efi"
    "EFI/OC/Tools/OpenShell.efi"
    "EFI/OC/Tools/BootKicker.efi"
    "EFI/OC/Tools/OpenControl.efi"
    "EFI/OC/Tools/ResetSystem.efi"
    "EFI/OC/Drivers/OpenRuntime.efi"
    "EFI/OC/Drivers/OpenCanopy.efi"
    "EFI/OC/Drivers/AudioDxe.efi"
)

function http_archive_repository() {
    work="$(mktemp -d)"
    cd "${work}"
    curl -L -o payload.zip "${1}"
    unzip payload.zip > /dev/null
    echo "${work}"
}

function update_opencore() {
    repo="$(http_archive_repository https://github.com/acidanthera/OpenCorePkg/releases/download/${OPENCORE_VERSION}/OpenCore-${OPENCORE_VERSION}-RELEASE.zip)"
    for f in ${OPENCORE_FILES[@]}; do
        cp -f "${repo}/X64/${f}" "${WORKSPACE}/${f}"
    done
    rm -rf "${repo}"
}

function update_resources() {
    repo="$(http_archive_repository https://github.com/acidanthera/OcBinaryData/archive/${OC_BINARY_DATA_VERSION}.zip)"
    cp -rf "${repo}/OcBinaryData-${OC_BINARY_DATA_VERSION}/Resources" "${WORKSPACE}/EFI/OC"
    rm -rf "${repo}"
}

function update_resources() {
    repo="$(http_archive_repository https://github.com/acidanthera/OcBinaryData/archive/${OC_BINARY_DATA_VERSION}.zip)"
    rsync -av --delete "${repo}/OcBinaryData-${OC_BINARY_DATA_VERSION}/Resources" "${WORKSPACE}/EFI/OC/Resources"
    rm -rf "${repo}"
}

function update_kext() {
    repo="$(http_archive_repository ${2})"
    rsync -av --delete "${repo}/${1}" "${WORKSPACE}/EFI/OC/Kexts/"
    rm -rf "${repo}"
}

update_opencore
update_resources
update_kext "Lilu.kext" "https://github.com/acidanthera/Lilu/releases/download/${LILU_VERSION}/Lilu-${LILU_VERSION}-RELEASE.zip"
update_kext "Kexts/VirtualSMC.kext" "https://github.com/acidanthera/VirtualSMC/releases/download/${VIRTUAL_SMC_VERSION}/VirtualSMC-${VIRTUAL_SMC_VERSION}-RELEASE.zip"
update_kext "WhateverGreen.kext" "https://github.com/acidanthera/WhateverGreen/releases/download/${WHATEVERGREEN_VERSION}/WhateverGreen-${WHATEVERGREEN_VERSION}-RELEASE.zip"
update_kext "AppleALC.kext" "https://github.com/acidanthera/AppleALC/releases/download/${APPLE_ALC_VERSION}/AppleALC-${APPLE_ALC_VERSION}-RELEASE.zip"
update_kext "NVMeFix.kext" "https://github.com/acidanthera/NVMeFix/releases/download/${NVME_FIX_VERSION}/NVMeFix-${NVME_FIX_VERSION}-RELEASE.zip"
