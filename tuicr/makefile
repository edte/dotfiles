SOURCE_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
TARGET_DIR := $(HOME)/.config/tuicr

.PHONY: all

all:
	@mkdir -p "$(TARGET_DIR)"
	@for name in config.toml themes; do \
		source="$(SOURCE_DIR)/$$name"; \
		target="$(TARGET_DIR)/$$name"; \
		if [ -e "$$target" ] && [ ! -L "$$target" ]; then \
			echo "Refusing to replace non-symlink: $$target" >&2; \
			exit 1; \
		fi; \
		ln -sfn "$$source" "$$target"; \
	done
