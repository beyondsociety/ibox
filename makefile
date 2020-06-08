NORMAL=\033[0;m
GREEN_TEXT=\033[1;32m

cross:
	@echo ''
	@echo "${GREEN_TEXT}Running Build Script..${NORMAL}"
	sh ./scripts/run-cross.sh

clang:
	@echo ''
	@echo "${GREEN_TEXT}Running Build Script..${NORMAL}"
	sh ./scripts/run-clang.sh

toolchain:
	@echo ''
	@echo "${GREEN_TEXT}Setting Up Toolchain..${NORMAL}"
	sh ./tools/cross-compiler.sh	

qemu:
	@echo ''
	@echo "${GREEN_TEXT}Running Qemu..${NORMAL}"
	sh ./scripts/qemu-meson-wrapper.sh

bochs:
	@echo ''
	@echo "${GREEN_TEXT}Running Bochs..${NORMAL}"
	sh ./scripts/bochs-meson-wrapper.sh


