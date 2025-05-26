# TACOS: Team Anant's CubeSat Operating System
TACOS is the operating system that will be used on team Anant's CubeSat mission.
# Features
- Support for Linux 6.12
# Steps to build image
### Install kas (One time)
```bash
pip install kas
```
### Set up the sources
First, clone this repository
```bash
git clone https://github.com/team-anant/tacos
```
Next, edit the local-env.sh file to match your build environment and then source it
```bash
cd tacos
source ./local-env.sh
```
Now you can start the build process with:
```bash
kas-container build
```
Alternatively, use `kas-container checkout` to checkout all the sources and make any required modifications
You can find the build artifacts in `tacos/build/tmp/deploy/images/bleedingbone/`
In order to transfer the image to a beaglebone black via an uSD card:
```bash
sudo bmaptool copy tmp/deploy/images/bleedingbone/taco.wic /dev/XYZ
#XYZ is the device node for your uSD card
```
Alternatively, you can just close your eyes and use any other image flasher to flash the .wic image onto the SD card.
