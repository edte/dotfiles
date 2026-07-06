RIME_HOME := /Users/edte/Library/Rime
REPO_DIR := $(CURDIR)
SQUIRREL := /Library/Input Methods/Squirrel.app/Contents/MacOS/Squirrel
RIME_DICT_MANAGER := /Library/Input Methods/Squirrel.app/Contents/MacOS/rime_dict_manager

.PHONY: all bootstrap userdb restore-userdb

all:
	mkdir -p $(RIME_HOME)
	stow . -t $(RIME_HOME)

bootstrap: all restore-userdb

userdb:
	"$(SQUIRREL)" --sync

restore-userdb:
	"$(SQUIRREL)" --quit || true
	sleep 1
	@for file in sync/current/*.userdb.txt; do \
		(cd "$(RIME_HOME)" && "$(RIME_DICT_MANAGER)" -r "$(REPO_DIR)/$$file"); \
	done
