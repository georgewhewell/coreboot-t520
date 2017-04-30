#!/bin/bash
set -e

cd /coreboot/

echo "Copying config"
cp /build/config.txt .config

echo "Reading layout"
/coreboot/util/ifdtool/ifdtool -f layout.txt /build/rom/stock.bin

echo "Extracting bios"
/coreboot/util/ifdtool/ifdtool -x /build/rom/stock.bin

echo "Extracting VGA bios"
/coreboot/UEFITool/UEFIExtract/UEFIExtract /build/rom/stock.bin 9781FA9D-5A3B-431A-AD59-2748C9A170EC 0AFCDD7A-345E-415E-926D-C5971B580400 || \
  echo "ignoring error.."

echo "Copying VGA bios"
NVIDIA_ROM=$(find stock.bin.dump -wholename '*9781FA9D-5A3B-431A-AD59-2748C9A170EC*/0 Raw section/body.bin')
INTEL_ROM=$(find stock.bin.dump -wholename '*0AFCDD7A-345E-415E-926D-C5971B580400*/0 Raw section/body.bin')
cp "$NVIDIA_ROM" nvidia.vga.rom
cp "$INTEL_ROM" intel.vga.rom

echo "Checking VGA ROM"
echo $(romheaders nvidia.vga.rom)
echo $(romheaders intel.vga.rom)

echo "Building image"
make CPUS=8

echo "Add VGA BIOS"
./build/cbfstool build/coreboot.rom add -f intel.vga.rom -c lzma -n pci8086:0106.rom -t raw
./build/cbfstool build/coreboot.rom add -f nvidia.vga.rom -c lzma -n pci10de,1057.rom -t raw

echo "Exporting ROM/layout"
cp build/coreboot.rom layout.txt /build/
