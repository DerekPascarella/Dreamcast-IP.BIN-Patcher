# Dreamcast IP.BIN Patcher v1.0
A utility to apply both region flag and text patches to a Dreamcast IP.BIN file.

This utility will patch both the single-byte region flag(s) starting at offset `0x30` (decimal `48`), and the 28-byte region text string(s) starting at offset `0x3704` (decimal `14084`) inside of IP.BIN.

<img src="https://raw.githubusercontent.com/DerekPascarella/Dreamcast-IP.BIN-Patcher/main/images/48.png">

<img src="https://raw.githubusercontent.com/DerekPascarella/Dreamcast-IP.BIN-Patcher/main/images/14084.png">

When rebuilding a GDI with a modified IP.BIN (e.g., shipping a translation patch), certain emulators will refuse to boot the disc image unless both of these areas are patched consistently.  While using an emulator's HLE BIOS option can avoid this issue, this BIOS can sometimes lead to compatibility issues not present in the stock Dreamcast BIOS.

Note that ODEs have no such region-flag consistency requirements.  However, for perfectionist's sake, and given that many are playing Dreamcast games via emulators, this utility can be helpful for those who do want to supply a region-modified IP.BIN with their patch.

### Region Flags:
`J` Japan/Taiwan/Philipines

`U` United States/Canda

`E` Europe

### Example Usage:
Generic usage:
```
ip_patch <REGION> <FILE>
```
Patch Japan/Taiwan/Philipines region flag and text:
```
ip_patch J C:\some\path\IP.BIN
```
Patch Japan/Taiwan/Philipines and United States/Canada region flag and text:
```
ip_patch JU C:\some\path\IP.BIN
```
Patch Japan/Taiwan/Philipines and Europe region flag and text:
```
ip_patch JE C:\some\path\IP.BIN
```
Patch Japan/Taiwan/Philipines, United States/Canada, and Europe region flag and text:
```
ip_patch JUE C:\some\path\IP.BIN
```
Patch United States/Canada region flag and text:
```
ip_patch U C:\some\path\IP.BIN
```
Patch United States and Europe region flag and text:
```
ip_patch UE C:\some\path\IP.BIN
```
Patch Europe region flag and text:
```
ip_patch E C:\some\path\IP.BIN
```
