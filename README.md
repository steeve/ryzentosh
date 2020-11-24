# Ryzentosh
This is the OpenCore configuration for macOS Big Sur 11.0.1 running on the ASUS
Crosshair VIII Hero (Wi-Fi) X570 motherboard with an AMD Ryzen 3950x and Radeon
5500 XT.

All of this was done following the great [OpenCore Install Guide](https://dortania.github.io/OpenCore-Install-Guide/) with the [Ryzen peculiarities]( https://dortania.github.io/OpenCore-Install-Guide/AMD/zen.html#kernel). It is way less complex that it
seems and is higly a recommended read.

## What's working
| Component                      | Status |    |
|--------------------------------|:------:|:---|
| AMD Ryzen 3950x                | ✅     | via [AMD kernel patches](https://github.com/AMD-OSX/AMD_Vanilla/tree/opencore) |
| Processor tempeture, frequency | ✅     | via [SMCAMDProcessor](https://github.com/trulyspinach/SMCAMDProcessor) |
| Sleep                          | ❓     | Unknown as I have no use for it yet |
| NVMe                           | ✅     | probably via [NVMeFix.kext](https://github.com/acidanthera/NVMeFix) |
| SATA                           | ✅     | native |
| USB                            | ✅     | via SSDT injection |
| On-Board audio                 | ❌     | [AppleALC](https://github.com/acidanthera/AppleALC) is injected but couldn't find a layout id that worked. See [this guide](https://dortania.github.io/OpenCore-Post-Install/universal/audio.html). I use an external DAC anyway. |
| Intel AX200 Bluetooth          | ✅     | apparently native (USB) |
| Intel AX200 Wi-Fi              | ❌     | [AirportItlwm](https://github.com/OpenIntelWireless/itlwm) could perhaps do the trick. I use wired ethernet. |
| Realtek 2.5gbps ethernet       | ✅     | via [LucyRTL8125Ethernet.kext](https://github.com/Mieze/LucyRTL8125Ethernet) |
| Radeon 5500 XT                 | ✅     | via [WhateverGreen.kext](https://github.com/acidanthera/WhateverGreen) |
| Radeon 5500 XT Audio (DP/HDMI) | ✅     | via via [WhateverGreen.kext](https://github.com/acidanthera/WhateverGreen) |

## Important GPU information
I have a GeForce 2080 Ti as the main GPU (first slot), and a Radeon 5500 XT as
the macOS GPU (second slot). As such, I have disabled the first PCI slot for
macOS with the following in `DeviceProperties.Add` (you might want to remove
that depending in your needs):
```xml
			<key>PciRoot(0x0)/Pci(0x3,0x1)/Pci(0x0,0x0)</key>
			<dict>
				<key>class-code</key>
				<data>/////w==</data>
				<key>IOName</key>
				<string>#display</string>
				<key>name</key>
				<data>I2Rpc3BsYXk=</data>
			</dict>
```

## Required BIOS configuration
Make sure the BIOS configuration is set [as per the guide](https://dortania.github.io/OpenCore-Install-Guide/AMD/zen.html#amd-bios-settings).

## Regarding SMBios
The machine is configured as `iMacPro1,1`.

Because SMBios serial numbers are required, the `config.plist` isn't present in
the `EFI/OC` directory, but rather a `config.tpl.plist` in which the serial
numbers are `CHANGEME`.

As per the guide, use [GenSMBios](https://github.com/corpnewt/GenSMBIOS) to
generate valid serials.

On macOS, it is possible to run `make config` to generate a final `config.plist`
from a `serials.txt` with the following format:
```
MLB XXXX
SystemSerialNumber YYYY
SystemUUID ZZZZ
```

I personally use the `make sync` command to generate and synchronize my `EFI`
folder.
