## **How to use the meson build system**
Meson requires two main dependences to run: \
**Python 3 and Ninja** 

On Ubuntu these can be easily installed with the following command: \
**$ sudo apt-get install python3 python3-pip ninja-build**

The best way to get Meson is to use **pip install** for the user. \
**$ pip3 install --user meson**

This will install the package in **~/.local/**, so you will have to add **~/.local/bin** to your **PATH**.

You can also get the Meson package from your distro, but beware that due to their frequent release cycle and development speed, the distro version might be out of date. Another option is to clone the git repository and run **./meson.py** directly from the meson folder. 

## **How to build Ibox**
If you need a build environment for Ibox, see the wiki below. If you just want to build Ibox, ignore the build instructions on the wiki and instead run **make** followed by either **cross** for the cross-compiler build or **clang** for the clang build.

Instructions on how to build ibox are found on the [Wiki](https://github.com/beyondsociety/ibox/wiki) .
