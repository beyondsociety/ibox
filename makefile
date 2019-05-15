NORMAL=\033[0;m
GREEN_TEXT=\033[1;32m

cross:
	@echo ''
	@echo "Running Build Script"
	sh ./scripts/run-cross.sh

clang:
	@echo ''
	@echo "${GREEN_TEXT}Running Build Script${NORMAL}"
	sh ./scripts/run-clang.sh

