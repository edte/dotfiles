RIME_HOME := /Users/edte/Library/Rime
REPO_DIR := $(CURDIR)
SQUIRREL := /Library/Input Methods/Squirrel.app/Contents/MacOS/Squirrel
RIME_DICT_MANAGER := /Library/Input Methods/Squirrel.app/Contents/MacOS/rime_dict_manager
USER_DICT := rime_frost
TMP_SYNC_DIR := tmp

.PHONY: all bootstrap userdb restore-userdb

bootstrap: all restore-userdb

all:
	mkdir -p $(RIME_HOME)
	stow . -t $(RIME_HOME)


userdb:
	@set -e; \
	test -d "$(RIME_HOME)/$(USER_DICT).userdb"; \
	"$(SQUIRREL)" --quit || true; \
	sleep 1; \
	(cd "$(RIME_HOME)" && "$(RIME_DICT_MANAGER)" -b "$(USER_DICT)"); \
	mkdir -p "sync/current"; \
	cp "$(TMP_SYNC_DIR)/current/$(USER_DICT).userdb.txt" "sync/current/$(USER_DICT).userdb.txt"; \
	rm -f "$(TMP_SYNC_DIR)/current/$(USER_DICT).userdb.txt"; \
	rmdir "$(TMP_SYNC_DIR)/current" 2>/dev/null || true; \
	echo "wrote sync/current/$(USER_DICT).userdb.txt"

restore-userdb:
	"$(SQUIRREL)" --quit || true
	sleep 1
	@for file in sync/current/*.userdb.txt; do \
		(cd "$(RIME_HOME)" && "$(RIME_DICT_MANAGER)" -r "$(REPO_DIR)/$$file"); \
	done
