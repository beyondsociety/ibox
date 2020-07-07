## **How to use the meson build system**
Meson requires two main dependences to run: ```Python 3 and Ninja```

On Ubuntu these dependencies can be easily installed with the following command: \
```$ sudo apt-get install python3 python3-pip python3-setuptools python3-wheel ninja-build```

The best way to get Meson is by using Python's install manager named Pip, we use pip3 for python version 3. \
If you want you can install meson system-wide by typing ```$ pip3 install meson```, 
however it is recommended to install as a local user by typing ```$ pip3 install --user meson```.

You can also get the Meson package from your distro, but beware that due to their frequent release cycle and development speed, the distro version might be out of date. Another option is to clone the git repository and run ```./meson.py``` directly from the meson folder. Installing Meson as a local user will install the package in ```~/.local/```, so you will have to add ```~/.local/bin``` to your **PATH**.

## **How to update meson and its dependencies**
To update meson to the newest version, we type: ```$ pip3 install --upgrade meson ```

If you get a message like: ```WARNING: You are using pip version 20.0.2; however, version 20.1 is available. You should consider upgrading via the 'usr/bin/python3 -m pip install --upgrade pip' command```, this means you need to update pip as well. (Pip = Pip3, so just use **pip3 install --upgrade pip** unless you have Python 2 installed as well, then use pip). 

## **How to build Ibox**
If you need a build environment for Ibox, see the wiki below. If you just want to build Ibox, ignore the build instructions on the wiki and instead run the build script by typing **./build.sh** into a linux terminal. 

```
Build options for Ibox
-------------------------------------------
1. Run cross-compiler build
2. Run clang build
3. Build toolchain
4. Run iso using Qemu
5. Run iso using Bochs
6. Quit

clear - Cleara the screen
```

Instructions on how to build ibox are found on the [Wiki](https://github.com/beyondsociety/ibox/wiki) .
