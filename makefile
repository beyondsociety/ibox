NORMAL=\033[0;m
GREEN_TEXT=\033[1;32m

cross:
	@echo ''
	@echo "${GREEN_TEXT}Running Build Script..${NORMAL}"
	./tools/scripts/run-cross.sh

clang:
	@echo ''
	@echo "${GREEN_TEXT}Running Build Script..${NORMAL}"
	./tools/scripts/run-clang.sh

toolchain:
	@echo ''
	@echo "${GREEN_TEXT}Setting Up Toolchain.."
	@echo "${GREEN_TEXT}Must run toolchain manually from commandline: target and prefix-dir."
	@echo "${NORMAL}Ex: ./tools/scripts/cross-compiler.sh i686-elf /usr/local/cross"
	#./tools/scripts/cross-compiler.sh

qemu:
	@echo ''
	@echo "${GREEN_TEXT}Running Qemu..${NORMAL}"
	./tools/scripts/qemu-meson-wrapper.sh

bochs:
	@echo ''
	@echo "${GREEN_TEXT}Running Bochs..${NORMAL}"
	./tools/scripts/bochs-meson-wrapper.sh
